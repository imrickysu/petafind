set -E
trap 'echo Failed on line: $LINENO at command: $BASH_COMMAND && exit $?' ERR

# make sure this is a petalinux directory
function pfroot {
   local cwd_tmp="$PWD"
   petalinux_project_base='' #global

   for(( ; ; ))
   do
      if [ "$cwd_tmp" = '/' ]; then
         if [ "$petalinux_project_base" = '' ]; then
            echo Note: NOT in a PetaLinux project directory
            export petafind_in_project_dir=0
            return
         fi
         break;
      fi

      if [ -d "$cwd_tmp/.petalinux" ]; then
      # Control will enter here if $DIRECTORY exists.
         petalinux_project_base="$cwd_tmp"
         export petalinux_project_base="$cwd_tmp"
         export petafind_in_project_dir=1
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
      echo -e "\n------ Project Metadata ------"
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

         # tmp (for build log)

         tmp_loc=$(grep CONFIG_TMP_DIR_LOCATION ${petalinux_project_base}/project-spec/configs/config)
         # echo ${tmp_loc}
         
         IFS='=' read -r name value <<< "$tmp_loc" # split line to name and value
         
         # remove "" of value
         value=${value#'"'}
         value=${value%'"'}
         # echo ${value}

         petalinux_project_tmp=$value

         echo "PetaLinux Project TMP: ${petalinux_project_tmp}"

         echo ""

      fi
   fi
}

function petafind  {
   # print banner
   echo "--------------------------"
   echo "petafind v0.1"
   echo "--------------------------"
   echo ""

   # print help when no options
   if [ $# -eq 0 ]; then
      echo "Usage:"
      echo "petafind <type> <keyword>"
      echo "- type: recipe, bsp, log, config, dts, root, tmp, u-boot"
      echo "- keyword: the sarch target of type"
      return 
   fi
  
   # Has at least one option

   # Check whether this is a petalinux project directory
   pfroot #if not will return. So all below assumes in petalinux project
   petalinux_project_metadata

   # Check tool environment
   if [[ ${PETALINUX} == "" ]]; then
      echo "Please source settings.sh in PetaLinux installation directory"
      return
   else
      petalinux_install_yocto_recipe=${PETALINUX}/components/yocto/source/${petalinux_project_arch}/layers

   fi
   

   case $1 in

      "root" )

      ;;

      "u-boot" | "u" )
      echo -e "\n------ U-boot Configuration Files ------"
      petalinux_project_uboot_platform_top=${petalinux_project_metauser}/recipes-bsp/u-boot/files/platform-top.h
      if [ -a ${petalinux_project_uboot_platform_top} ]; then
         echo "platform-top.h: ${petalinux_project_uboot_platform_top}"
      fi


      ;;


      "recipe" | "r" )
      echo -e "\n------ Search Recipes ------"

      # if with one keyword
      # Find recipe name in current project meta-user and petalinux installation directory
      # Check whether this recipe has been enabled in rootfs
      if [[ $2 != "" ]]; then
         printf "\nSearching $2 in project meta-user layer\n\n"
         find  ${petalinux_project_metauser} -name "$2"
         #TODO: find $2 in ${petalinux_install_yocto_recipe}
         printf "\nSearching $2 in PetaLinux installation directory for ${petalinux_project_arch}\n\n"
         find ${petalinux_install_yocto_recipe} -name "$2"
      else

      # If no keyword
      # print recipe directory
         echo "Project meta-user layer"
         printf "\t${petalinux_project_metauser}\n"

         echo "PetaLinux Install Yocto layer for ${petalinux_project_arch}"
         printf "\t${petalinux_install_yocto_recipe}\n"
      fi

      ;;

      "bsp" )
      # Print the BSP location
      # If keyword is available, filter with keyword

      ;;

      "log" )
      # Print the build log location
      # If keyward is available, filter log name with keyword
      petalinux_project_log=${petalinux_project_tmp}/work

      ;;

      "config" )
      # Print the path of 
      # - project configuration
      # - rootfs configurations
      # - rootfs image configuration
      # - kernel configuration

      # only work for petalinux project dir
      if [ ${petafind_in_project_dir} -ne 1 ]; then
         return
      fi

      echo -e "\n------ Project Configuration Files ------"

      petalinux_project_config=${petalinux_project_base}/project-spec/configs/config
      if [ -a ${petalinux_project_config} ]; then
         echo -e "Project Config File: ${petalinux_project_config}"
      else
         echo -e "Project Config File: Not found"
      fi

      petalinux_project_rootfs_config=${petalinux_project_base}/project-spec/configs/rootfs_config
      if [ -a ${petalinux_project_rootfs_config} ]; then
         echo -e "\nProject Rootfs Config File: ${petalinux_project_rootfs_config}"
      else
         echo -e "\nProject Rootfs Config File: Not found"
      fi

      petalinux_project_rootfs_additional="${petalinux_project_base}/project-spec/meta-user/recipes-core/images/petalinux-image.bbappend"
      if [ -a ${petalinux_project_rootfs_additional} ]; then
         echo -e "\nProject Rootfs Additional Config: ${petalinux_project_rootfs_additional}"
      else
         echo -e "\nProject Rootfs Additional Config: Not found"
      fi
      echo -e "- Note: Add recipes supported by Yocto but not listed in PetaLinux rootfs to IMAGE_INSTALL_append"

      petalinux_project_kernel_config=${petalinux_project_tmp}

      ;;

      "dts" )
      # Print all dts and dtsi file locations

      ;;

      "tmp" )

      if [ -a ${petalinux_project_base}/project-spec/configs/config ]; then
         grep TMP ${petalinux_project_base}/project-spec/configs/config
      else
         echo "Error: project configure file not found"
      fi

      ;;

   esac
 
}
