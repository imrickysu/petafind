# make sure this is a petalinux directory
function pfroot {
   local cwd_tmp="$PWD"
   petalinux_project_base='' #global

   for(( ; ; ))
   do
      if [ "$cwd_tmp" = '/' ]; then
         if [ "$petalinux_project_base" = '' ]; then
            echo Note: NOT in a PetaLinux project directory
            return
         fi
         break;
      fi

      if [ -d "$cwd_tmp/.petalinux" ]; then
      # Control will enter here if $DIRECTORY exists.
         petalinux_project_base="$cwd_tmp"
         export petalinux_project_base="$cwd_tmp"
         echo Project Base: $petalinux_project_base
      fi

      # test upper directory
      cwd_tmp="$(dirname "$cwd_tmp")"
   done
}

# Check project version, target SoC family
# Output
# - petalinux_project_version
# - petalinux_project_metauser
# - petalinux_project_family
function petalinux_project_metadata {
   if [ -a ${petalinux_project_base} ]; then
      metadata_path=${petalinux_project_base}/.petalinux/metadata
      if [ -a ${metadata_path} ]; then
          read line < ${metadata_path} # read file to line
         IFS='=' read -r name value <<< "$line" # split line to name and value
         export petalinux_project_version=$value
         echo PetaLinux Project Version: ${petalinux_project_version}

         # meta-user path
         export petalinux_project_metauser=${petalinux_project_base}/project-spec/meta-user
      fi

      # family
      config_path=${petalinux_project_base}/project-spec/configs/config
      if [ -a ${config_path} ]; then
         if grep -q BOOTLOADER_NAME_ZYNQ_FSBL ${config_path}; then
            petalinux_project_family="zynq"
            petalinux_project_arch="arm"
         fi
         if grep -q BOOTLOADER_NAME_ZYNQMP_FSBL ${config_path}; then
            petalinux_project_family="zynqMP"
            petalinux_project_arch="aarch64"
         fi
         if grep -q BOOTLOADER_NAME_FS_BOOT ${config_path}; then
            petalinux_project_family="microblaze"
            petalinux_project_arch="microblaze_full"
         fi

         if [[ ${petalinux_project_family} ==  "" ]]; then
            echo PetaLinux Project Family: Not found
            exit
         else
            echo PetaLinux Project Family: ${petalinux_project_family}
            export petalinux_project_family=${petalinux_project_family}
            export petalinux_project_arch=${petalinux_project_arch}
         fi

      fi
   fi
}

function petafind  {
   # print banner
   echo "petafind v0.1"
   echo ""

   # print help when no options
   if [ $# -eq 0 ]; then
      echo "Usage:"
      echo "petafind <type> <keyword>"
      echo "- type: recipe, bsp, log, kernelconfig, dts, root, tmp"
      echo "- keyword: the sarch target of type"
      return 
   fi
  
   # Has at least one option

   # Check whether this is a petalinux project directory
   pfroot #if not will return
   petalinux_project_metadata

   # Check tool environment
   if [ ${PETALINUX} == "" ]; then
      echo "Please source PetaLinux settings.sh"
      return
   else
      petalinux_install_yocto_recipe=${PETALINUX}/components/yocto/source/${petalinux_project_arch}/layers

   fi
   



   case $1 in

      "root" )

      ;;


      "recipe" | "r" )


      # if with one keyword
      # Find recipe name in current project meta-user and petalinux installation directory
      # Check whether this recipe has been enabled in rootfs
      if [[ $2 != "" ]]; then
         printf "\nSearching $2 in project meta-user layer\n\n"
         find  ${petalinux_project_metauser} -name "$2*.bb*"
         #TODO: find $2 in ${petalinux_install_yocto_recipe}
         printf "\nSearching $2 in PetaLinux installation directory for ${petalinux_project_arch}\n\n"
         find ${petalinux_install_yocto_recipe} -name "$2*.bb*"
      fi

      # If no keyword
      # print recipe directory


      ;;

      "bsp" )


      ;;

      "log" )


      ;;

      "kernelconfig" )

      ;;

   esac
 
}
