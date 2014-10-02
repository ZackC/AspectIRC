package aspects.color;

import java.awt.Color;
import java.awt.FlowLayout;
import java.awt.Panel;
import java.awt.LayoutManager;

import javax.swing.JComboBox;
import javax.swing.JLabel;

import common.Message;

import client.Client;
import client.OptionsPanel;

public privileged aspect ColorAspect {

	JComboBox<String> fontColor = null;
	JComboBox<String> backgroundColor;

	void around(Client c, Message msg): this(c) && execution(public void send(Message)) && args(msg){
		if (fontColor != null) {
			String oldHeader = msg.getHeader();
			String newHeader;
			if (oldHeader == null || oldHeader.trim() == "") {
				newHeader = "font=" + ((String) fontColor.getSelectedItem())
						+ ", background="
						+ ((String) backgroundColor.getSelectedItem());
			} else {
				newHeader = "font=" + ((String) fontColor.getSelectedItem())
						+ ", background="
						+ ((String) backgroundColor.getSelectedItem()) + ", "
						+ oldHeader;
			}
			msg = new Message(newHeader, msg.getContent());
			System.out.println("new color header: " + newHeader);
		}
		proceed(c, msg);
		// return msg;
	}

	after(OptionsPanel op): this(op)  && call(public void setLayout(LayoutManager)) {
		String[] selectableColors = { "black", "white", "red", "green", "blue" };
		fontColor = new JComboBox<String>(selectableColors);
		fontColor.setSelectedIndex(0);
		backgroundColor = new JComboBox<String>(selectableColors);
		backgroundColor.setSelectedIndex(1);
		Panel fontColorPanel = new Panel();
		fontColorPanel.setLayout(new FlowLayout());
		fontColorPanel.add(new JLabel("Font Color:"));
		fontColorPanel.add(fontColor);
		Panel backgroundColorPanel = new Panel();
		backgroundColorPanel.setLayout(new FlowLayout());
		backgroundColorPanel.add(new JLabel("Background Color:"));
		backgroundColorPanel.add(backgroundColor);
		op.add(fontColorPanel);
		op.add(backgroundColorPanel);
	}

	void around(Client c, Object msg): this(c) && execution(protected void handleIncomingMessage(Object)) && args(msg){
		if (msg instanceof Message) {
			Message msg1 = (Message) msg;
			String header = msg1.getHeader();
			System.out.println("color plugin received header: " + header);
            int fontPos = header.indexOf("font=");
            if (fontPos != -1) {
                int commaPos = header.substring(fontPos).indexOf(",");	
				//int pos = header.indexOf(',');
				String fontColorString = header.substring(fontPos+5, fontPos+commaPos);
				System.out.println("font color selection: " + fontColorString);
				// change font color in gui
				Color fontColor = getColor(fontColorString);
				c.getGui().getTextArea().setForeground(fontColor);
				msg1.setHeader(header.substring(0,fontPos)+ header.substring(fontPos+commaPos+ 2));
			} 
            header = msg1.getHeader();
            int backgroundPos = header.indexOf("background=");
            if (backgroundPos != -1) {
				int commaPos = header.substring(backgroundPos).indexOf(",");
				String backgroundColorString = header.substring(backgroundPos+11, backgroundPos+commaPos);
				System.out.println("background color selection: "
						+ backgroundColorString);
				// change background in gui
				Color backgroundColor = getColor(backgroundColorString);
				c.getGui().getTextArea().setBackground(backgroundColor);
				msg1.setHeader(header.substring(0,backgroundPos)+header.substring(backgroundPos+commaPos + 2));
			}
            proceed(c,msg1);
		}
		else{
           proceed(c,msg);
		}
	}

	private Color getColor(String colorString) {
		if (colorString.equals("white")) {
			return Color.WHITE;
		} else if (colorString.equals("black")) {
			return Color.BLACK;
		} else if (colorString.equals("red")) {
			return Color.RED;
		} else if (colorString.equals("green")) {
			return Color.GREEN;
		} else if (colorString.equals("blue")) {
			return Color.BLUE;
		}
		return null;
	}
}
