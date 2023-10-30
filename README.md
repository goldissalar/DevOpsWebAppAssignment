# DevOpsAssignment1

Übung2:

Deployment:

Der Deployment-Controller mit dem Namen "devops-webapp" sorgt dafür, dass eine bestimmte Anzahl von Pods (in diesem Fall 2) bereitgestellt wird. Dieser Controller steuert auch Aktualisierungen der Anwendung.
Der Container innerhalb des Pods verwendet das Bild "goldissalar/devops-webapp:1.0" und hat eine spezifische Ressourcenkonfiguration.
Es sind Readiness- und Liveness-Proben konfiguriert, die sicherstellen, dass die Anwendung ordnungsgemäß läuft.
Die Strategie für Updates ist als Rolling Update festgelegt.


Service:

Der Service mit dem Namen "devops-webapp-service" ermöglicht den Zugriff auf die bereitgestellte Anwendung.
Er verwendet Port 80 und leitet den Datenverkehr an Port 3000 der Pods weiter.


HorizontalPodAutoscaler (HPA):

Die HPA-Ressource mit dem Namen "web-app-hpa" ist für die automatische Skalierung der Pods verantwortlich.
Sie ist so konfiguriert, dass sie die Anzahl der Pods basierend auf der CPU-Auslastung anpasst. Wenn die CPU-Auslastung 30% erreicht, werden bis zu 5 Pods erstellt.
Die HPA-Ressource arbeitet mit dem Deployment "devops-webapp" zusammen.

ich habe durch den Befehl kubectl run -i --tty load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://devops-webapp-service/; done" ein load-generator ausgeführt um zu überprüfen, ob weitere Pods erstellt werden, wenn die Auslastung erreicht wurde.

Hier ist zu sehen, dass es funktioniert hat:
<img width="598" alt="image" src="https://github.com/goldissalar/DevOpsAssignment1/assets/68482747/02c2d13e-9707-4d29-ba78-2e7a287e1bda">
