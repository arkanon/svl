#!/bin/bash

# DiPoHLo - Distribuição Portável do HotLogo
#
# Build Script
#
# Arkanon <arkanon@lsd.org.br>
# 2015/07/04 (Sáb) 03:41:25 BRS
# 2015/07/03 (Sex) 09:13:11 BRS
# 2015/07/03 (Sex) 02:35:49 BRS
# 2015/07/02 (Qui) 00:12:35 BRS
# 2015/07/01 (Qua) 00:53:04 BRT
# 2014/03/07 (Fri) 00:52:56 BRS
# 2014/03/05 (Wed) 22:21:10 BRS
# 2013/04/15 (Seg) 05:49:49 BRS



  NAME="DiPoHLo - Distribuição Portável do HotLogo"
   MAJ="0.11.0"

   rpm="ftp://rpmfind.net/linux/fedora/linux/development/rawhide"
    sf="http://downloads.sourceforge.net/openmsx"
  pref="openmsx-$MAJ"

  # arquiteturas do emulador
  arc[0]="x86"    ; pkg[0]="$rpm/i386/os/Packages/o/$pref-4.fc23.i686.rpm"
  arc[1]="x64"    ; pkg[1]="$rpm/x86_64/os/Packages/o/$pref-4.fc23.x86_64.rpm"
  arc[2]="w86"    ; pkg[2]="$sf/$pref-windows-vc-x86-bin.zip"
  arc[3]="w64"    ; pkg[3]="$sf/$pref-windows-vc-x64-bin.zip"
  arc[4]="m86_64" ; pkg[4]="$sf/$pref-mac-x86_64-bin.dmg"

  typeset -A cls # classes de arquitetura
  cls[x86]="i386"
  cls[x64]="x86_64"

  # dependencias
  lib[0]="l/libstdc++-5.1.1-4.fc23"
  lib[1]="l/libao-1.2.0-5.fc23"
  lib[2]="l/libpng-1.6.17-2.fc23"
  lib[3]="l/libGLEW-1.10.0-6.fc23"
  lib[4]="s/SDL_ttf-2.0.11-7.fc23"

  bpath=$PWD/$MAJ/bin
  lpath=$PWD/$MAJ/lib/$(uname -m | grep -q x86_64 && echo x64 || echo x86)

  export      TIMEFORMAT='  ELAPSED TIME: %lR'
  export            PATH=$PATH:$bpath
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$lpath

  echo
  echo "export            PATH=\$PATH:$bpath"
  echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$lpath"
  echo



  BLD=$(($(tail -n1 build-history 2> /dev/null | cut -f1)+1)) # update build number
  VER="$MAJ-$BLD"

  echo -e "$BLD\t$(LC_TIME=C date +'%Y/%m/%d (%a) %H:%M:%S %Z')" >> build-history

  mkdir -p $MAJ
  (
    cd $MAJ

    touch v$MAJ

    for i in bin lib share
    do
      rm    -rf $i
      mkdir -p  $i
    done

    mkdir -p .pkg
    (
      cd .pkg

      for i in $(seq ${#pkg[*]})
      do

           n=$((i-1))
         url=${pkg[$n]}
        arch=${arc[$n]}

        echo ${url##*/}

        time wget -qc $url

        mkdir tmp
        (
          cd tmp

          case $arch in

            x*) 7z e -so ../${url##*/} 2> /dev/null | cpio -idm --quiet
                rm                            usr/share/openmsx/settings.xml
                mv   etc/openmsx/settings.xml usr/share/openmsx
                mv   usr/bin/openmsx          ../../bin/$pref-$arch
                mv   usr/share/openmsx/       ../../share/$arch/
                ;;

            w*) 7z x ../${url##*/} &> /dev/null
                mv   codec/      share/
                mv   openmsx.exe ../../bin/$pref-$arch.exe
                mv   share/      ../../share/$arch/
                ;;

            m*) 7z x ../${url##*/} &> /dev/null
                7z x 4.hfs         &> /dev/null
                mv   openMSX/openMSX.app/ ../../bin/$pref-$arch.app
                ;;

          esac

        ) # tmp
        rm -r tmp

      done

    ) # .pkg

    # ldd bin/openmsx-0.11.0-4.fc23.i686 | grep 'not found'
    # # usr/bin/openmsx: /usr/lib/i386-linux-gnu/libstdc++.so.6: version GLIBCXX_3.4.21 not found (required by usr/bin/openmsx)
    #
    # strings /usr/lib/i386-linux-gnu/libstdc++.so.6 | grep GLIBC
    # # GLIBCXX_3.4.20
    #
    # dpkg -S libstdc++.so.6
    # apt-file -l search libstdc++.so.6
    #
    # strings lib-i386/libstdc++.so.6 | grep GLIBC
    # # GLIBCXX_3.4.21

    mkdir -p .dep
    (
      cd .dep

      for class in x86 x64
      do

        arch=${cls[$class]}

        mkdir -p ../lib/$class

        for i in $(seq ${#lib[*]})
        do

            n=$((i-1))
          url="$rpm/$arch/os/Packages/${lib[$n]}.${arch/3/6}.rpm"

          echo ${url##*/}

          time wget -qc $url

          mkdir tmp
          (
            cd tmp

            7z e -so ../${url##*/} 2> /dev/null | cpio -idm --quiet
            mv   usr/lib*/* ../../lib/$class

          ) # tmp
          rm -r tmp

        done

      done

    ) # .dep

    prefix="http://www.msxarchive.nl/pub/msx/emulator/openMSX/systemroms/machines/gradiente"
    time wget -qc $prefix/expert_ddplus_basic-bios1.rom
    time wget -qc $prefix/expert_ddplus_disk.rom
    sha1sum *.rom
    # d6720845928ee848cfa88a86accb067397685f02  expert_ddplus_basic-bios1.rom
    # f1525de4e0b60a6687156c2a96f8a8b2044b6c56  expert_ddplus_disk.rom

  ) # MAJ

  echo

exit #-- AQUI --#

  (

     cd share

     rm -r icons nettou_yakyuu playball extensions
     rm -r unicodemaps/unicodemap.{??,j*,br_hotbit*,proto_fr}
     rm -r skins/handheld
     rm -r skins/none
     rm -r skins/set?
     rm -r skins/*.png

     # scripts/ - carga de skin e do console
     # Vera     - teclado virtual
     # VeraMono - console

     mv machines/{README,Gradiente_Expert_DDPlus.xml} .
     rm -r machines/*
     mv README Gradiente_Expert_DDPlus.xml machines

     cp -a ../../.pkg/*.rom systemroms

  )

  mv    share/skins/fancy  share/skins/set1
  cp -a ../data/*.xml      share
  cp -a ../data/software/* share/software
  cp -a ../data/frame.png  share/skins/set1
  cp -a ../data/pixel.png  share/skins
  cp -a ../data/disk       .
  cp -a ../data/misc       .
  cp -a ../data/openmsx*   .

  mod=../data/cygwin
  ori=/export/data/soft/cygwin/cygwin
  dst=/export/home/arkanon/public_html/svl.lsd.org.br/appsweb/svl/.h/msx/emu/distro/$version/cygwin
  mkdir -p $dst
  (
    cd $mod
    find . -type f | while read f
    do
      ( cd $ori ; cp -a --parents $f $dst 2> /dev/null ) || ( cd $ori/fs ; cp -a --parents $f $dst )
    # ( cd $ori ; grep -aq '^!<symlink>' $ori/$f && cp -a $(grep -aEo '[^/].*$' $ori/$f) $dst/$(echo $f | cut -d/ -f2-) )
    done
  )
  cp -a ../data/profile cygwin/etc

  # diff -u ../../.share/scripts/load_icons.tcl load_icons.tcl >| ../../../data/load_icons.tcl.patch
  patch -p1 share/scripts/load_icons.tcl < ../data/load_icons.tcl.patch

# PARAMETROS="-script openmsx.tcl -machine Gradiente_Expert_DDPlus -cart share/software/hotlogo.rom -diska disk"
#
# OPENMSX_SYSTEM_DATA=share
# LD_LIBRARY_PATH=lib OPENMSX_USER_DATA=share ./openmsx-bin $PARAMETROS
#
# wine openmsx-bin.exe $PARAMETROS

# EOF
