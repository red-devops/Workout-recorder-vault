# Workout-recorder - Hashicorp Vault Post Provisioning 

The content of this project is part of the post on blog https://red-devops.pl/<br>
The repository contains terraform code, thanks to which we can automatically create an infrastruture for the workoutrecorder application that can be found on the site:<br>
https://github.com/red-devops/Workout-recorder <br>
This is the next step in which we add the hashicorp vault tool to our infrastructure.<br> 
Post provisioning is done using ansible playbook in the repository:
https://github.com/red-devops/Vault-server-ansible <br>
In the implementation we use a self hosted runner which was built automatically using this repository: <br>
https://github.com/red-devops/Packer-guide