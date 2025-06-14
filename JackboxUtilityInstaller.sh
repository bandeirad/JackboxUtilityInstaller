#!/bin/bash

# Stop on any error
set -e

# --- Configuration ---
# Use variables for easy modification and readability.
readonly USER_HOME="/home/chronos"
readonly CUSTOM_BIN_DIR="${USER_HOME}/.local/bin" # Using .local/bin is a more common convention
readonly APPLICATION_DESKTOP_DIR="${USER_HOME}/.local/share/applications"
readonly UTIL_DIR="${USER_HOME}/JackboxUtility"
readonly UNZIP_URL="https://oss.oracle.com/el4/unzip/unzip.tar"
readonly JACKBOX_URL="https://github.com/AlexisL61/JackboxUtilityUpdater/releases/latest/download/JackboxUtility_Linux.zip"

# --- Helper Functions ---
# A function for logging messages.
log() {
    echo "--> ${1}"
}

# A function to check if a command exists.
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# --- Main Script Logic ---
main() {
    export PATH="${CUSTOM_BIN_DIR}:${PATH}"
    log "Starting JackboxUtility Setup for ChromeOS"

    # Create necessary directories
    log "Creating directories..."
    mkdir -p "${CUSTOM_BIN_DIR}"
    mkdir -p "${UTIL_DIR}"

    # Navigate to the utility directory
    cd "${UTIL_DIR}"

    # --- Setup Unzip Tool ---
    if ! command_exists unzip; then
        log "Unzip not found. Setting up a custom unzip tool..."
        # Use a temporary file for the download
        local temp_unzip
        temp_unzip=$(mktemp)
        log "Downloading unzip..."
        if wget -O "${temp_unzip}" "${UNZIP_URL}"; then
            log "Untar unzip to ${CUSTOM_BIN_DIR}"
            tar -xf "${temp_unzip}" -C "${CUSTOM_BIN_DIR}/"
            chmod +x "${CUSTOM_BIN_DIR}/unzip"
        else
            log "Error: Failed to download unzip. Aborting."
            exit 1
        fi
    else
        log "Unzip is already installed."
    fi

    # Ensure the custom bin directory is in the PATH for this session
    export PATH="${CUSTOM_BIN_DIR}:${PATH}"

    # --- Download and Install JackboxUtility ---
    log "Downloading JackboxUtility..."
    local temp_zip
    temp_zip=$(mktemp)
    if wget -O "${temp_zip}" "${JACKBOX_URL}"; then
        log "Unzipping JackboxUtility..."
        unzip -o "${temp_zip}" -d "${UTIL_DIR}" # -o overwrites without prompting, -d specifies destination
        rm -f "${temp_zip}"
    else
        log "Error: Failed to download JackboxUtility. Aborting."
        exit 1
    fi

    # --- Create a Starter Script ---
    log "Creating starter script..."
    cat > "${UTIL_DIR}/start.sh" << EOF
#!/bin/bash

# Set the working directory to the location of the script
cd "\$(dirname "\$0")"

# Add custom binaries to the PATH
export PATH="${CUSTOM_BIN_DIR}:\${PATH}"

# Set the DISPLAY variable for GUI applications
export DISPLAY=":0"

# Execute the main application
./JackboxUtility
EOF

    log "Making starter script executable..."
    chmod u+x "${UTIL_DIR}/start.sh"

    # --- Create a Desktop Application File ---
    log "Creating desktop application file..."
    cat > "${APPLICATION_DESKTOP_DIR}/JackboxUtility.desktop" << EOF

[Desktop Entry]
Name=Jackbox Utility
Exec=/home/chronos/JackboxUtility/start.sh
Icon=utilities-terminal
Type=Application
Terminal=true
Categories=Utility;Game;
EOF

    log "Making desktop application file executable..."
    chmod u+x "${APPLICATION_DESKTOP_DIR}/JackboxUtility.desktop"

    log "Setup complete!"
    log "To run the application, execute the following command:"
    log "    ${UTIL_DIR}/start.sh"
}

# Execute the main function
main
