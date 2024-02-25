#### Jetbrains YouTrack
Sourced from Official YouTrack Docker Image and ZIP Distribution. The images are auto-updated weekly
    
License: https://www.jetbrains.com/legal/docs/youtrack/license/
    
#### Tags    
latest           = built from jetbrains official docker image  
version numbered = built from source using zip, base is Ubuntu LTS
    
#### Build:    
If YOUTRACK_VERSION is omitted, your build will be based on the latest release available
````
docker build . --build-arg YOUTRACK_VERSION=1234.2.2022 --tag YOUR_TAG
````
    