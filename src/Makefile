#SAD Makefile

all:	
	ghdl -a --std=02 --ieee=synopsys sad.vhd

	ghdl -a --std=02 --ieee=synopsys sad_test.vhd
	ghdl -e --std=02 --ieee=synopsys sad_tb
	ghdl -r --std=02 --ieee=synopsys sad_tb --vcd=../testbench/sad.vcd

	ghdl -a --std=02 --ieee=synopsys sad_n.vhd

	ghdl -a --std=02 --ieee=synopsys sad_n_test.vhd
	ghdl -e --std=02 --ieee=synopsys sad_n_tb
	ghdl -r --std=02 --ieee=synopsys sad_n_tb --vcd=../testbench/sad_n.vcd
	
sad:
	ghdl -a --std=02 --ieee=synopsys sad.vhd

test:
	ghdl -a --std=02 --ieee=synopsys sad_test.vhd
	ghdl -e --std=02 --ieee=synopsys sad_tb
	ghdl -r --std=02 --ieee=synopsys sad_tb --vcd=../testbench/sad.vcd

sad_n:
	ghdl -a --std=02 --ieee=synopsys sad_n.vhd

test_n:
	ghdl -a --std=02 --ieee=synopsys sad_n_test.vhd
	ghdl -e --std=02 --ieee=synopsys sad_n_tb
	ghdl -r --std=02 --ieee=synopsys sad_n_tb --vcd=../testbench/sad_n.vcd

clean:
	rm -r *.o
	rm -r *.cf
	rm -r *_tb

