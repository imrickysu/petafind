# make sure this is a petalinux directory
function pfroot {
   local cwd_tmp="$PWD"
   petalinux_proj_base='' #global

   for(( ; ; ))
   do
      if [ "$cwd_tmp" = '/' ]; then
         if [ "$petalinux_proj_base" = '' ]; then
            echo Note: NOT in a PetaLinux project directory
            return
         fi
         break;
      fi

      if [ -d "$cwd_tmp/.petalinux" ]; then
      # Control will enter here if $DIRECTORY exists.
         petalinux_proj_base="$cwd_tmp"
         export petalinux_proj_base="$cwd_tmp"
         echo Project Base: $petalinux_proj_base
      fi

      # test upper directory
      cwd_tmp="$(dirname "$cwd_tmp")"
   done
}

function petalinux_project_metadata {
   if [ -a ${petalinux_proj_base} ]; then
      metadata_path=${petalinux_proj_base}/.petalinux/metadata
      if [ -a ${metadata_path} ]; then
          read line < ${metadata_path} # read file to line
         IFS='=' read -r name value <<< "$line" # split line to name and value
         export petalinux_proj_version=$value
         echo PetaLinux Project Version: ${petalinux_proj_version}
         export petalinux_project_metauser=${petalinux_proj_base}/project-spec/meta-user
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
      petalinux_install_yocto_recipe=${PETALINUX}/

   fi
   



   case $1 in

      "root" )

      ;;


      "recipe" | "r" )


      # if with one keyword
      # Find recipe name in current project meta-user and petalinux installation directory
      # Check whether this recipe has been enabled in rootfs
      if [[ $2 != "" ]]; then
         echo Searching $2 in ${petalinux_project_metauser}
         find  ${petalinux_project_metauser} -name "$2*.bb*"
         #TODO: find $2 in ${petalinux_install_yocto_recipe}
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
