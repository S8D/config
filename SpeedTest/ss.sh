#!/bin/bash
PhienBan="20200328c"
UpLink="https://bom.to/sss"
pem="/etc/ssl/cert.pem"; mkdir -p /etc/ssl
uPem="https://bom.to/pem"
u64="https://bom.to/sp64"
uArm="https://bom.to/sparm"
uAR="https://bom.to/sp64a"
TM="/sd/sp"; mkdir -p $TM
upTam="$TM/tam"
GetTime=$(date +"%F %a %T"); Time="$GetTime -"; DauCau="#"
if [ ! -f "$pem" ]; then echo "Đang tải chứng chỉ..."; curl -sLo $pem $uPem; fi

OS=`uname -m`; x64="x86_64"; arm="armv7l"; Android="aarch64"
if [ $OS == $x64 ]; then upem=$u64; sp="/usr/sbin/sp"; fi
if [ $OS == $arm ]; then upem=$uArm; if [ -d /www/cgi-bin ]; then sp="/usr/sbin/sp"; else sp="/opt/sbin/sp"; fi; fi
if [ $OS == $Android ]; then upem=$uAR; sp="/system/xbin/sp"; echo "OS: $OS | Android"; fi

if [ ! -f "$sp" ]; then echo "Đang tải SpeedTest..."; curl -sLo $sp $upem; chmod +x $sp; fi
#echo "Chưa hỗ trợ hệ thống bạn đang dùng"; exit 1

Giup ()
{
	echo ""
	echo "Cú pháp gõ:"
	printf '\t\t'; echo "$(basename "$0") [ -h | -a | -s | -v ]"
	echo ""
	echo "Chức năng:"
	printf '\t\t'; echo -n "[ -h ]"; printf '\t'; echo "Hiện hướng dẫn sử dụng"
	printf '\t\t'; echo -n "[ -a ]"; printf '\t'; echo "Kiểm tra tốc độ mạng tới tất cả máy chủ"
	printf '\t\t'; echo -n "[ -s ]"; printf '\t'; echo "Kiểm tra tốc độ mạng tới máy chủ Singapore"
	printf '\t\t'; echo -n "[ -v ]"; printf '\t'; echo "Kiểm tra tốc độ mạng tới máy chủ Việt Nam"
	echo ""
}

while getopts "h?asv" opt; do
	case ${opt} in
		h|\? ) Giup ;;
		a    ) echo "Kiểm tra tốc độ mạng tới tất cả máy chủ"; sp -B -s 9575; sp -B -s 6106 ;;
		s    ) echo "Kiểm tra tốc độ mạng tới máy chủ Singapore"; sp -B -s 9575 ;;
		v    ) echo "Kiểm tra tốc độ mạng tới máy chủ Việt Nam"; sp -B -s 6106 ;;
	\? ) exit 2 ;;
	esac
done
shift $((OPTIND-1))

echo "$DauCau Đang kiểm tra cập nhật $(basename "$0") $PhienBan..."
PhienBanMoi=$(curl -sL "${UpLink}" | grep PhienBan\= | sed 's/.*\=\"//; s/\"$//');
if [ $PhienBanMoi == $PhienBan ]; then echo "$DauCau $(basename "$0") $PhienBan là bản mới nhất!";        
else echo "$DauCau Đang cập nhật $(basename "$0") v.$PhienBan lên v.$PhienBanMoi...";
	cp $0 ${TM}/$PhienBan\_$(basename "$0")
	curl -sLo $upTam $UpLink; chmod +x $upTam; cp ${upTam} ${DV}/$(basename "$0"); rm -rf $upTam
	echo "$DauCau Khởi chạy $(basename "$0") $PhienBanMoi..."; ${DV}/$(basename "$0"); exit 1; fi;
Giup