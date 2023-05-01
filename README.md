```
# Docker Registry Cleanup Script

This script cleans up old Docker image tags in a Docker registry. It removes all tags except the most recent one for each repository.

## Usage

1. Clone the repository and navigate to the project directory:

   git clone https://github.com/example/docker-registry-cleanup.git
   cd docker-registry-cleanup

2. Install the required dependencies:

   # Install doctl CLI (https://github.com/digitalocean/doctl)
   brew install doctl
   
   # Configure doctl with your DigitalOcean API token
   doctl auth init

3. Modify the script to define the repositories to clean up:

   # Define the repositories to clean up
   REPOSITORIES=(prod-api dev-api)

4. Run the script:
   bash cleanup.sh


   The script will prompt you to confirm before deleting each tag. If you want to skip the prompt, you can add the `--force` flag to the `doctl registry repository delete-tag` command in the script.

   Note that the script will skip repositories with no tags and exclude the most recent tag for each repository.

## License

This script is licensed under the [MIT License](LICENSE).
