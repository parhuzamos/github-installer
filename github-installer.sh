#!/bin/bash
defdir=/opt
app=${1}

function ask_continue() {
	read -p  "Continue? [y/n] " -n 1 -s response
	if [ ! "${response}" = "y" ]; then
		echo "${response}"
		echo
		echo "User abort. Exiting."
		exit 1;
	fi
	echo "${response}"
	echo
}

echo "Installing ${app}..."
echo
read -p "Select a directory to install to (a subdirectory will be created here): [${defdir}] " ${installdir}
if [ "${installdir}" = "" ]; then
	installdir=${defdir}
fi
installdir=$(realpath ${installdir})/${app}
echo -e "\n$app will be installed to \"${installdir}\""
ask_continue
git clone https://github.com/parhuzamos/${app}.git ${installdir}
exitcode=$?
if [ ! "${exitcode}" = "0" ]; then
	echo
	echo "Program error (${exitcode}). Exiting."
	exit ${exitcode}
fi
OIFS=IFS
IFS=":"
echo "Select a directory to place symlink(s):"
select linkdir in $PATH; do
	break;
done
IFS=$OIFS
if [ "${linkdir}" = "" ]; then
	echo "User abort. Exiting."
	exit 1;
fi
lindir=$(realpath $linkdir)
executables=""
count=0
for file in ${installdir}/*; do
	if $(head -n 1 ${file} | grep "#\!/" >/dev/null); then
		if [[ "${executables}" = "" ]]; then
			executables=$file
		else
			executables=${executables}:$file
		fi;
		count=$((count+1))
	fi
done
echo "Creating ${count} symlink(s) in \"${linkdir}\""
ask_continue
OIFS=IFS
IFS=":"
for executable in ${executables}; do
	filename=$(basename "${executable}")
	filename="${filename%.*}"
	echo "Link ${executable} -> ${linkdir}/${filename}"
	ln -s ${executable} ${linkdir}/${filename}
done
IFS=$OIFS
uninstall=${installdir}/uninstall.sh
echo "#!/bin/bash" >${uninstall}
echo "rm -rf ${installdir}" >>${uninstall}
OIFS=IFS
IFS=":"
for executable in ${executables}; do
	filename=$(basename "${executable}")
	filename="${filename%.*}"
	echo "rm ${linkdir}/${filename}" >>${uninstall}
done;
IFS=$OIFS
chmod +x ${uninstall}
echo
echo "Installation successfull."
echo "To uninstall execute the just created \"uninstall.sh\": "
echo "    ${uninstall}"
echo
echo "Done."