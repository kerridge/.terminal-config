# ----------------------------------------------
# -------------------- SET OS ------------------
# ----------------------------------------------
unameOut="$(uname -s)"
case "${unameOut}" in
  Linux*)     os=Linux;;
  Darwin*)    os=Mac;;
  CYGWIN*)    os=Windows;;
  MINGW*)     os=Windows;;
  *)          os="UNKNOWN:${unameOut}"
esac


# ----------------------------------------------
# ------------- SET CURRENT MACHINE ------------
# ----------------------------------------------
machineName="$(hostname)"
case "$machineName" in
  LM-C02F44ZYMD6R*) currentMachine="Work Macbook";;
  KERRIDGE-PC*)     currentMachine="Home PC";;
  XLW-5CD0036MR8*)  currentMachine="Work PC";;
  *)                currentMachine="Unrecognized Device - ${machineName}"
esac