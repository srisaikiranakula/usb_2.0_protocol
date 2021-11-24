# usb_2.0_protocol
Code files of my BTP 

The folder consists of all code files that I have used to implement Universal Serial Bus 2.0 protocol in VHDL.
All design files have their corresponding name.
All the test benches for the corresponding design codes have "_tb" at the end.

The top level block of the design is present in _usb.vhd_ file. 
The _usb.vhd_ design consists of transmitter, receiver, controller, dummy host and tristate components in it. 

The test benches for _usb.vhd_ is present in **usb_tb_in.vhd** for IN token packet without _error_ and in **usb_tb_in_error.vhd** for IN token packet with _error_ and in **usb_tb_out.vhd** for OUT token without _error_ and in **usb_tb_out_error.vhd** for OUT token with _error_ in DATA packet and in **usb_tb_out_error_2.vhd** for OUT token with _error_ in OUT token packet itself.
