#!/bin/bash

# Navigate to the user's home directory.
# In ChromeOS, /home/chronos is the primary user's home.
cd /home/chronos

# --- Setup a custom unzip tool ---
# This is necessary on some locked-down systems like ChromeOS
# where standard package managers (apt, yum) are not available.

# Create a hidden directory in the home folder to store custom binaries.
echo "Creating a directory for custom binaries..."
mkdir -p /home/chronos/.bin

# Download a pre-compiled 'unzip' binary as a tar archive.
# Note: This is a very old version of unzip, but it's self-contained.
echo "Downloading unzip tool..."
/usr/bin/wget https://oss.oracle.com/el4/unzip/unzip.tar

# Extract the 'unzip' binary from the downloaded tar file.
echo "Extracting unzip..."
/usr/bin/tar -xf ./unzip.tar

# Clean up by removing the downloaded tar file.
/usr/bin/rm -f ./unzip.tar

# Move the extracted 'unzip' binary into the custom bin directory.
echo "Installing unzip to /home/chronos/.bin/"
/usr/bin/mv ./unzip /home/chronos/.bin/

# --- Update PATH Environment Variable ---
# Add the custom binary directory to the shell's PATH.
# This allows the system to find and execute 'unzip' from any directory.
export PATH="$PATH:/home/chronos/.bin"
echo "Updated PATH for the current session."

# --- Download and Install JackboxUtility ---

# Create a dedicated directory for the JackboxUtility.
echo "Creating directory for JackboxUtility..."
mkdir -p /home/chronos/JackboxUtility

# Navigate into the newly created directory.
cd /home/chronos/JackboxUtility

# Download the latest version of JackboxUtility for Linux.
echo "Downloading JackboxUtility..."
/usr/bin/wget https://github.com/AlexisL61/JackboxUtilityUpdater/releases/latest/download/JackboxUtility_Linux.zip

# Unzip the application files using the custom unzip tool.
# We use the full path to be explicit.
echo "Unzipping JackboxUtility..."
/home/chronos/.bin/unzip ./JackboxUtility_Linux.zip

# Clean up by removing the downloaded zip file.
/usr/bin/rm -f ./JackboxUtility_Linux.zip

# --- Create a Starter Script for Easy Launching ---

# Create a new shell script file named 'JackboxUtilityStarter.sh'.
# The > operator creates the file and adds the first line.
echo "Creating starter script..."
echo '#!/bin/bash' > JackboxUtilityStarter.sh
echo '# This script sets up the environment and runs JackboxUtility.' >> JackboxUtilityStarter.sh

# Add the custom bin directory to the PATH inside the starter script.
# This ensures 'unzip' or other tools in .bin are available when the script runs.
# The \$PATH ensures that the PATH variable is evaluated at runtime, not at creation time.
echo 'export PATH=$PATH:/home/chronos/.bin' >> JackboxUtilityStarter.sh

# Set the DISPLAY environment variable. This is crucial for GUI applications
# to know which screen to draw on. :0 is typically the primary display.
echo 'export DISPLAY=":0"' >> JackboxUtilityStarter.sh

# Add the command to execute the main application file.
# Note: The executable name is case-sensitive. Assuming it is 'JackboxUtility'.
echo './JackboxUtility' >> JackboxUtilityStarter.sh

# Make the starter script executable.
# chmod 775 gives read/write/execute permissions to the user and group,
# and read/execute permissions to others.
echo "Making starter script executable..."
chmod 775 ./JackboxUtilityStarter.sh

echo "Setup complete!"
echo "You can now run the application by executing:"
echo "cd /home/chronos/JackboxUtility && ./JackboxUtilityStarter.sh"
