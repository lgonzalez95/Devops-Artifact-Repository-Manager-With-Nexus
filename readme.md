# Module Description
This document guides you through setting up and managing a Nexus Repository Manager on a DigitalOcean droplet. It covers installation, user setup, repository configuration, and artifact management with Gradle, Maven, and NPM. It also includes Nexus API usage, cleanup policies, and automation for downloading and running the latest application version.

### Install Nexus
1. Create a new droplet with 8GB of ram
2. Install Java 17: `apt install openjdk-17-jre-headless`
3. In the terminal, execute: `cd /opt`
4. Download Nexus: `wget https://download.sonatype.com/nexus/3/nexus-3.77.1-01-unix.tar.gz`
5. Unzip the file: `tar -zxvf nexus-3.77.1-01-unix.tar.gz `

### Create Nexus user, change permissions of the Nexus installation folder, and setup its user
1. Create user: `adduser nexus`
2. Update folders owner:\
   `chown -R nexus:nexus nexus-3.77.1-01`\
   `chown -R nexus:nexus sonatype-work/`\
3. Update user for nexus: `vim nexus-3.77.1-01/bin/nexus.rc`
4. Uncomment the line and enter the `nexus` user created
5. Save the file

### Starting nexus
1. Switch to nexus user: `su - nexus`;
2. Start nexus: `/opt/nexus-3.77.1-01/bin/nexus start`
3. Check it is running: `ps aux | grep nexus`
4. Make sure to open the firewall port for Nexus, in this case por `8081`

### Nexus repo types:
1. proxy: There is another repository and we add its link, so that nexus can grab the packages from there if there haven't been fetched yet.
2. hosted: Repository for private company artifacts.
3. group: Allows to combine multiple repositories and even other repository groups in a single repository, allowing to have 1 single url to retrieve packages.

### Other tasks done
1. Cloned a gradle and maven repo
2. Configured the repos to push the artifacts to nexus
3. Explored the nexus API:\
 `curl -u user:password -X GET 'http://144.126.218.34:8081/service/rest/v1/repositories'`\
 `curl -u user:password -X GET 'http://144.126.218.34:8081/service/rest/v1/components?repository=maven-snapshots'`

 ### Notes:
 1. Components contain assests
 2. The component would be the parent folder that contains the application
 3. Basically components is what we are uploading to nexus.

### Cleanup policies
1. Nexus policies determine how artifacts (dependencies, libraries, or packages) are stored, updated, and removed in a repository
2. Proper policies prevent excessive storage usage by automatically managing old snapshots while retaining stable releases.

## Exercises notes:
### Publish NPM package to Nexus
1. Create NPM hosted repository
2. Create a user with read access to the created repository.
3. Encode the user credentials running the command `echo -n "user:password" | base64`
3. Configure the NPM authentication
   - create a `.npmrc` file in the home folder
   - Add the following content to the file to be able to publish artifacts to the repository:\
   `registry=http://144.126.218.34:8081/repository/hosted-repositories-node-app/
//144.126.218.34:8081/repository/hosted-repositories-node-app/:_auth="ENCODED_CREDENTIALS"
email=nodeuser@testing.com
always-auth=true`

3. Build the npm project using `npm package`
4. Run the command `npm publish --registry=http://144.126.218.34:8081/repository/hosted-repositories-node-app/` from the project root folder

### Download the application from Nexus
1. Run this command to download the lastest application version: `curl -u user:password -L -X GET "http://144.126.218.34:8081/service/rest/v1/search/assets/download?sort=version&repository=hosted-repositories-node-app" -H "accept: application/json" > node-app.tgz`
2. Unzip the application: `tar -xvfz node-app.tgz`
3. Execute `npm install` from the application parent folder
4. Run `npm run start`

#### Note:
Execute `bash DownloadRunLastNexusNodeAppArtifact.sh` to download and start the application automatically from the Digital Ocean Droplet