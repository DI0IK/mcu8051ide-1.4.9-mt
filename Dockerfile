# MCU 8051 IDE (Tcl/Tk) - containerized runtime
# Provides GUI via X11 forwarding (Linux host) and stores user settings via a volume.

FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install Tcl/Tk runtime + common Tcl packages MCU8051IDE expects.
# Package names can vary slightly between distros; these are correct for Debian/Ubuntu families.
RUN apt-get update && apt-get install -y --no-install-recommends \
    tcl tk \
    tcllib tclx \
    itcl3 \
    tdom \
    bwidget \
    libtk-img \
    ca-certificates \
    xauth \
    && rm -rf /var/lib/apt/lists/*

# App lives here
WORKDIR /opt/mcu8051ide

# Copy repository contents into the image
COPY . /opt/mcu8051ide

# Create a non-root user (recommended for GUI apps)
RUN useradd -m -u 1000 appuser \
    && chown -R appuser:appuser /opt/mcu8051ide

USER appuser

# Persist user settings (location depends on the app; keeping home persistent is usually enough)
VOLUME ["/home/appuser"]

# X11 GUI environment variables will be passed at runtime.
# Run directly from the repo layout: main.tcl is under lib/
CMD ["tclsh", "/opt/mcu8051ide/lib/main.tcl"]