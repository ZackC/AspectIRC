package aspects.log;

import java.awt.BorderLayout;
import java.awt.TextArea;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.LayoutManager;
import java.util.ArrayList;

import javax.swing.JButton;
import javax.swing.JFrame;

import java.net.ServerSocket;

import client.OptionsPanel;

import server.Server;
import common.Message;
import client.Client;

public privileged aspect LogAspect {

	TextArea outputArea = null;
	JButton printLogButton;
	ArrayList<String> log = new ArrayList<String>();
	
	after(final Server server): call(ServerSocket.new(int)) && this(server){
		JFrame frame = new JFrame("log output");
		frame.setLayout(new BorderLayout());
		outputArea = new TextArea();
		frame.add("Center", outputArea);
		printLogButton = new JButton("print server log");
		printLogButton.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				if (outputArea != null) {
					for (String line : log) {
						outputArea.append(line + "\n");
					}
				}

			}
		});
		frame.add("South", printLogButton);
		frame.pack();
		frame.setVisible(true);
	}
	
	after(OptionsPanel op): this(op)  && call(public void setLayout(LayoutManager)) {
		printLogButton = new JButton("print client log");
		outputArea = op.g.getTextArea();
		printLogButton.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				if (outputArea != null) {
					for (String line : log) {
						outputArea.append(line + "\n");
					}
				}

			}
		});
		op.add(printLogButton);
	}
	
	before (String line): this(Client) && execution(public void fireAddLine(String)) && args(line){
	  log.add(line);
	}
	
	void around (Server s, Message msg): this(s) && execution(public void broadcast(Message)) && args(msg){
		log.add("Header: "+msg.getHeader()+"; Message: "+msg.getContent());
		proceed(s,msg);
	}
	
}
