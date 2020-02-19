# teamspeak-bosh-release

A BOSH release of the TeamSpeak application

## Usage

1. Clone the repo
2. Create the release
    ```
    bosh create-release releases/teamspeak/teamspeak-{VERSION}.yml --tarball teamspeak.tgz
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

## Example for creating new release `3.11.0` and deploy

1. Clone the [repo](git@github.com:pivotal-cf-experimental/teamspeak-bosh-release.git).
1. Copy the existed package in folder `packages` and rename it to the latest version of teamspeak. e.g.: `teamspeak-3.11.0`.
1. Update the `packaging` file in `packages/teamspeak-LATESTVERSION`  to replace the url with the latest teamspeak server release url.
1. Update the `BINARYPATH` in the file `jobs/teamspeak/templates/ctl.sh.erb` with the latest version. (e.g.: /var/vcap/packages/teamspeak-3.11.0)
1. Create the bosh release with the command: `bosh -e pizza create-release --name teamspeak --version=3.11.0 --final --force --tarball=teamspeak.tgz`
1. Upload the release to bosh environment with the command:
```
bosh -e pizza upload-release teamspeak.tgz
```
1. Modify the manifest `teamspeak-bosh-v2.yml` in the folder `examples` if you can not deploy with it. You can find the deployment from example directory.
1. Bosh deploy. ```bosh -e pizza -d teamspeak deploy teamspeak-bosh-v2.yml -v teamspeak-admin-token=<YOUR_UNIQUE_ID>```
1. Bosh ssh if you want to verify the job status. 
  1.  ssh to the vm```bosh -e pizza -d teamspeak ssh teamspeak```
  1. ``` monit summary```

## Bugs

This release only works on Ubuntu (it uses `apt-get` to install SQLite3

The *TeamSpeak* server runs as root.  TeamSpeak documentation discourages this (security)
