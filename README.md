# File-Integrity-Monitor
## Worked on from July 20 - 25, 2022

Created a proof of concept File Integrity Monitor(FIM) in powershell that sends alerts on modifications made to file system to allow further investigation of potential compromises. The user can either collect a new baseline of their files and store its file|hash pairs in a baseline.txt, or monitor files with a saved baseline to notify user if anything has been compromised.

Created an integrity baseline of target files using the SHA-512 hashing algorithm. 
![baseline ss](https://user-images.githubusercontent.com/70961105/180883042-779182ef-365a-4457-876b-d25863472107.JPG)

Continuously made comparison of actual files to the stored baseline, alerting the system if any deviations occured.
![New file](https://user-images.githubusercontent.com/70961105/180883193-7387d58b-b6ec-4884-b6a8-21ba4e281cc1.JPG)
![changed file](https://user-images.githubusercontent.com/70961105/180883217-3228f207-399e-4c80-aded-c4b43ab1f567.JPG)
![deleted file](https://user-images.githubusercontent.com/70961105/180883235-3231b3c9-849c-4775-9c82-4d36dd56b0d0.JPG)

If you receive a message saying **".ps1 is not digitally signed. The script will not execute on the system"**, type in the following command in the terminal before running:
```Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass```
