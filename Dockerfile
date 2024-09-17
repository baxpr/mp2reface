## Start with FSL, ImageMagick, python3/pandas, xvfb base docker
# baxterprogers/fsl-base:v6.0.5.2  is on Ubuntu 20.04
FROM baxterprogers/fsl-base:v6.0.5.2

## General packages
#     universe needed for AFNI
#     software-properties-common needed for universe
RUN apt update && \
    apt install -y software-properties-common && \
    add-apt-repository universe && \
    apt update

## For AFNI on Ubuntu 20.04, https://afni.nimh.nih.gov/
  
# Packages
RUN apt install -y tcsh xfonts-base libssl-dev       \
                   python-is-python3                 \
                   python3-matplotlib                \
                   gsl-bin netpbm gnome-tweak-tool   \
                   libjpeg62 xvfb xterm vim curl     \
                   gedit evince eog                  \
                   libglu1-mesa-dev libglw1-mesa     \
                   libxm4 build-essential            \
                   libcurl4-openssl-dev libxml2-dev  \
                   libgfortran-8-dev libgomp1        \
                   gnome-terminal nautilus           \
                   gnome-icon-theme-symbolic         \
                   firefox xfonts-100dpi             \
                   r-base-dev

# Make a symbolic link for the specific version of GSL in this version of Ubuntu
RUN ln -s /usr/lib/x86_64-linux-gnu/libgsl.so.23 /usr/lib/x86_64-linux-gnu/libgsl.so.19

# AFNI binaries
RUN mkdir /opt/afni && cd /opt/afni && \
    curl -O https://afni.nimh.nih.gov/pub/dist/bin/misc/@update.afni.binaries && \
    tcsh @update.afni.binaries -package linux_ubuntu_16_64 -do_extras -bindir /opt/afni/abin

# AFNI setup and check
ENV PATH=/opt/afni/abin:${PATH}
RUN suma -update_env && \
    afni_system_check.py -check_all

# Install R packages for AFNI
ENV R_LIBS=/opt/R
RUN mkdir $R_LIBS && \
    rPkgsInstall -pkgs ALL

# Entrypoint
ENTRYPOINT ["bash"]
