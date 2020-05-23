#!/bin/bash
PhienBan="20200523b"
UpLink="https://bom.to/sss"
pem="/etc/ssl/cert.pem"; mkdir -p /etc/ssl
uPem="https://bom.to/pem"
u64="https://bom.to/sp64"
uArm="https://bom.to/sparm"
uAR="https://bom.to/sp64a"
umip="https://bom.to/spp"
SG="4235"
HK="16176"
VN="6106"
GetTime=$(date +"%F %a %T"); Time="$GetTime -"; DauCau="#"

if [ ! -f "$pem" ]; then echo "Đang tải chứng chỉ..."; curl -sLo $pem $uPem; fi

OS=`uname -m`; x64="x86_64"; arm="armv7l"; Android="aarch64"; mip="mips"

if [ $OS == $x64 ] || [ $OS == $arm ]; then TM="/sd"; mkdir -p $TM; fi
if [ $OS == $Android ]; then TM="/sdcard"; mkdir -p $TM; fi
SP="$TM/sp"; mkdir -p $SP; upTam="$SP/tam"
if [ $OS == $x64 ]; then upem=$u64; sp="/usr/sbin/sp"; fi
if [ $OS == $arm ]; then upem=$uArm; if [ -d /www/cgi-bin ]; then sp="/usr/sbin/sp"; else sp="/opt/sbin/sp"; fi; fi
if [ $OS == $Android ]; then upem=$uAR; sp="/system/xbin/sp"; fi
if [ $OS == $mip ]; then upem=$umip; sp="/system/xbin/sp"; fi

if [ ! -f "$sp" ]; then echo "Đang tải SpeedTest..."; curl -sLo $sp $upem; chmod +x $sp; fi
if [ $OS != $x64 ] && [ $OS != $arm ] && [ $OS != $Android ] && [ $OS != $mip ]; then echo "Chưa hỗ trợ hệ thống bạn đang dùng"; exit 1; fi

Giup ()
{
	echo ""
	echo "Cú pháp:"
	printf '\t'; echo "$(basename "$0") [ -h | -a | -s | -k | -v | -t [máy chủ] ]"
	echo ""
	echo "Chức năng:"
	printf '\t'; echo -n "[ -h ]"; printf '\t'; echo "Hiện hướng dẫn sử dụng"
	printf '\t'; echo -n "[ -a ]"; printf '\t'; echo "Kiểm tra tốc độ mạng tới tất cả máy chủ"
	printf '\t'; echo -n "[ -s ]"; printf '\t'; echo "Kiểm tra tốc độ mạng tới máy chủ Singapore [4235: StarHub | 7556: PT FirstMedia | 7311: M1 Limited | 20637: OVH Cloud | 5168: PT Indosat Tbk | 18791: FPT Telecom]"
	printf '\t'; echo -n "[ -k ]"; printf '\t'; echo "Kiểm tra tốc độ mạng tới máy chủ Hong Kong"
	printf '\t'; echo -n "[ -v ]"; printf '\t'; echo "Kiểm tra tốc độ mạng tới máy chủ Việt Nam"
	printf '\t'; echo -n "[ -t ]"; printf '\t'; echo "Kiểm tra tốc độ mạng tới máy chủ tùy chọn"
	echo ""
}

while getopts "h?askvt" opt; do echo ""
	case ${opt} in
		h|\? ) Giup ;;
		a    ) echo "Kiểm tra tốc độ mạng tới tất cả máy chủ"; if [ $OS == $mip ]; then sp --bytes --secure --server $SG; sp --bytes --secure --server $HK; sp --bytes --secure --server $VN; else sp -B -s $SG; sp -B -s $HK; sp -B -s $VN; fi ;;
		s    ) echo "Kiểm tra tốc độ mạng tới máy chủ Singapore"; if [ $OS == $mip ]; then sp --bytes --secure --server $SG; else sp -B -s $SG; fi ;;
		k    ) echo "Kiểm tra tốc độ mạng tới máy chủ Hong Kong"; if [ $OS == $mip ]; then sp --bytes --secure --server $HK; else sp -B -s $HK; fi ;;
		v    ) echo "Kiểm tra tốc độ mạng tới máy chủ Việt Nam"; if [ $OS == $mip ]; then sp --bytes --secure --server $VN; else sp -B -s $VN; fi ;;
		t    ) echo "Kiểm tra tốc độ mạng tới máy chủ tùy chọn"; echo -en "Nhập ID máy chủ: "; read -r t; if [ $OS == $mip ]; then sp --bytes --secure --server $t; else sp -B -s $t; fi ;;
		
	\? ) exit 2 ;;
	esac
done
shift $((OPTIND-1))
echo ""
echo "$DauCau Đang kiểm tra cập nhật $(basename "$0") $PhienBan..."
PhienBanMoi=$(curl -sL "${UpLink}" | grep PhienBan\= | sed 's/.*\=\"//; s/\"$//');
if [ $PhienBanMoi == $PhienBan ]; then echo "$DauCau $(basename "$0") $PhienBan là bản mới nhất!";        
else echo "$DauCau Đang cập nhật $(basename "$0") v.$PhienBan lên v.$PhienBanMoi...";
	cp $0 ${SP}/$PhienBan\_$(basename "$0")
	curl -sLo $upTam $UpLink; chmod +x $upTam; cp $upTam ${TM}/$(basename "$0"); rm -rf $upTam
	echo "$DauCau Khởi chạy $(basename "$0") $PhienBanMoi..."; sh ${TM}/$(basename "$0"); exit 1; fi;
Giup
