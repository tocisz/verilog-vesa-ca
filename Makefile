all: top.syr top.ngd top_map.ncd top.ncd top.bit

top.stx: top_stx.xst
	xst -intstyle ise -ifn $^ -ofn $@

top.syr: top_syr.xst
	mkdir -p xst/projnav.tmp
	xst -intstyle ise -ifn $^ -ofn $@

top.ngd: top.ngc
	ngdbuild -intstyle ise -dd _ngo -sd ipcore_dir -nt timestamp -uc vesa2.ucf -p xc6slx16-ftg256-2 $^ $@

top_map.ncd: top.ngd
	map -intstyle ise -p xc6slx16-ftg256-2 -w -logic_opt off -ol high -t 1 -xt 0 -register_duplication off -r 4 -global_opt off -mt off -ir off -pr off -lc off -power off -o $@ $^ top.pcf

top.ncd: top_map.ncd top.pcf
	par -w -intstyle ise -ol high -mt off $< $@ top.pcf

top.bit: top.ncd
	bitgen -intstyle ise -f top_bit.ut $^ $@
