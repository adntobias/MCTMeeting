# Trainertreff Repository

Im Verzeichnis `powershell` befindet sich ein Skript für den Versand einer Adaptive Card in einen Teams-Channel. Hierfür ist die Einrichtung eines [Incoming Webhooks](https://shorturl.at/nxYZ8) erforderlich.

Das Skript liest eine vorgefertigte Card und ersetzt dynamisch vordefinierte Werte. Die fertige Card wird daraufhin in einen Teams-Channel gepostet.

Die "Disable User" Card-Action Endpoint verweist auf eine Logic App mit HTTP-Trigger.

## Post-Incident Card 

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fStyx665%2fMCTMeeting%2fmain%2fLogic%2520Apps%2fSentinelPostCard.json)

Das Ziel ist es, den Incident in Teams darzustellen und direkt eine Aktion auszuführen.

![Rendered Card](imgs/Card.png)

Im Fall von Azure Sentinel erfolgt dies über eine Azure Logic App.

![Overview](imgs/Overview.png)

Der Workflow besteht aus einem Trigger und mindestens einer Aktion. Bei Meldung eines Incidents an Sentinel erhalten wir die Information, dass ein Incident mit ```ARM ID XY``` ausgelöst wurde. Über diese Info gelangen wir an alle weiteren Details. Beispielhaft suchen wir Empfänger und Absender einer Mail, indem wir die Entities durchsuchen.

![Loop Entities](imgs/loopEntities.png)

Ein Incident hat i.d.R. verschiedene Arten von Entities, wir interessieren uns für ```MailMessage```.

![Check Kind](imgs/checkKind.png)

Zum einfacheren Verarbeiten wird das JSON-Objekt geparst, somit haben wir direkten Zugriff auf alle Felder.

Anschließend fügen wir alle dynamischen Werte, also alles, was sich bei jedem neuen Durchlauf ändern kann, in die Card ein.

![Dynamic Values Card](imgs/CardDynValues.png)

Vor dem Posten der Card in den Channel entscheiden wir, abhängig von der ```Severity```, in welchen Channel wir was posten wollen.

![Check Severity](imgs/checkSeverity.png)

Für alle ernsten Vorfälle (```High```) posten wir die Card, um schnell die wichtigsten Schritte einzuleiten. Alle anderen Incidents werden als einfache Nachricht gepostet.

Wenn eine Aktion ausgeführt werden soll, warten wir auf die ```Response```.

![Card Response](imgs/postCardWaitResponse.png)

Die Aktion können wir selbst definieren und abfragen. Auf den zurückgegebenen Return-Wert wird dann entsprechend reagiert.

```json
{
  "actions": [
    {
      "title": "Disable User",    #<----- Return-Wert
      "type": "Action.Submit",
    },
    {
      "title": "Close Incident",  #<----- Return-Wert
      "type": "Action.Submit"
    }
  ],
  "type": "ActionSet"
}
```

## Post Powershell Card

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FStyx665%2FMCTMeeting%2Fmain%2FLogic%2520Apps%2FCardResponse.json)

- script verlinken
- card anpassung
- actions müssen anders entgegengenommen werden
- 

![Action Response PwrShll](imgs/pwrshllResponse.png)

## Card Designer

:red_circle: Verfügbare Elemente

:large_blue_circle: Genutze Elemente in Baumstruktur und deren Properties

:orange_circle: Das eigentliche JSON

:green_circle: Vorschau der gerenderten Card

:bangbang: Auf die Version und den Client achten

![Card Designer](imgs/CardDesigner.png)

#### TODO 
- Deployment errors, due to identity
- ARM Skript parameters
