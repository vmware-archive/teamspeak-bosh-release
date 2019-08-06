# teamspeak-bosh-release

A BOSH release of the TeamSpeak application

## Usage

1. Clone the repo
2. Create the release
    ```
    bosh create-release releases/teamspeak/teamspeak-3.9.1.yml --tarball teamspeak.tgz
    ```
    
3. Load the release to the BOSH director
    ```
    bosh upload-release teamspeak.tgz
    ```
    
4. Use an example manifest and tweak it for your specific configuration but be sure to provide a `teamspeak-admin-token` variable for the deployment

5. Run 
    ```
    bosh deploy -d teamspeak teamspeak.yml -v teamspeak-admin-token=<YOUR_UNIQUE_ID>
    ```
    
6. Spin up your teamspeak client and enter the public IP and the `teamspeak-admin-token` you created
7. You should then be prompted to enter the "Privileged Key" which is your `teamspeak-admin-token`

## Bugs

This release only works on Ubuntu (it uses `apt-get` to install SQLite3

The *TeamSpeak* server runs as root.  TeamSpeak documentation discourages this (security)
