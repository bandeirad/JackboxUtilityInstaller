# Jackbox Utility Installer for ChromeOS (Using Steam VM)-A "Works of Me" Project

***DISCLAIMER*:** This software is provided "as is," without any warranty of any kind, express or implied. The author assumes no responsibility for the correctness of these instructions or the functionality of the script. Use at your own risk.

***WARNING*:** This project modifies system files within the Steam VM (Borealis). There is a potential risk of damaging or destroying your working Steam VM environment. Proceed with caution and only if you understand the risks involved.

This script automates the installation of the Jackbox Utility within the Steam VM environment (Borealis) on a ChromeOS system. It downloads all necessary components, sets them up, and creates an application launcher for easy access.

## What This Script Does

The script performs the following steps automatically:

### Creates Directories

It sets up the necessary folders, including `~/.local/bin` for custom executables and `~/JackboxUtility` for the application itself.

### Checks and Installs `unzip`

The Steam VM does not always have the `unzip` tool installed. The script checks if `unzip` is available. If not, it downloads a compatible version and installs it to `~/.local/bin` for use during the setup process.

### Downloads Jackbox Utility

It fetches the latest Linux version of the Jackbox Utility from its official GitHub releases page.

### Extracts the Application

The downloaded `.zip` file is extracted into the `~/JackboxUtility` directory.

### Creates a Starter Script

A wrapper script named `start.sh` is created. This script ensures that:

* The application runs from the correct directory.
* The`DISPLAY` variable is set correctly, allowing the graphical user interface to appear on ChromeOS.
* The custom`bin` directory is included in the system's`PATH`.

### Creates a Desktop Shortcut

A `.desktop` file is placed in `~/.local/share/applications`. This makes the "Jackbox Utility" appear in your ChromeOS app launcher, allowing it to be started just like a native application.

## Prerequisites

* A ChromeOS device (Chromebook, Chromebox, etc.).
* The Steam application must be installed.
* An active internet connection to download the required files.
* Start the Steam application.
* Open the Crosh terminal by pressing`Ctrl` +`Alt` +`T`.
* Log into the VM by typing`vsh borealis`.

## Installation

1. **Download the script:**

   ```bash
   wget https://raw.githubusercontent.com/bandeirad/JackboxUtilityInstaller/refs/heads/main/JackboxUtilityInstaller.sh
   ```
2. **Make the Script Executable:**

   ```bash
   chmod +x JackboxUtilityInstaller.sh
   ```
3. **Run the Script:**
   Start the installation with this command:

   ```bash
   ./JackboxUtilityInstaller.sh
   ```

   The script will now execute all steps and inform you of its progress in the terminal.

## After Installation

Once the script has completed successfully, you have two ways to start the Jackbox Utility:

* **Via the App Launcher (Recommended):**
  * Click the Launcher (the circle in the corner of your screen).
  * Search for "Jackbox Utility." It should appear alongside your other apps.
  * Click the icon to start the application.
* **Manually via the Crosh Terminal:**
  * Open the Crosh terminal by pressing`Ctrl` +`Alt` +`T`.
  * Log into the VM with`vsh borealis`.
  * Run the utility's start script:`~/JackboxUtility/start.sh`

## Uninstallation

To remove the application, you will need to delete the created directories and files manually.

1. **Open the Crosh terminal** and log into the VM (`vsh borealis`).
2. **Remove the application directory and installation script:**

   ```bash
   rm -rf ~/JackboxUtility
   rm -f ~/JackboxUtilityInstaller.sh
   ```
3. **Remove the desktop shortcut:**

   ```bash
   rm ~/.local/share/applications/JackboxUtility.desktop
   ```
4. **(Optional) Remove the `unzip` tool if it was installed by the script:**

   ```bash
   rm ~/.local/bin/unzip
   ```

## Error Handling

The script uses `set -e`, which will cause it to exit immediately if any command fails. This is intended to prevent an inconsistent or broken installation.
