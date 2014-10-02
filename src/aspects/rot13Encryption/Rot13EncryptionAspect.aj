package aspects.rot13Encryption;

import java.awt.LayoutManager;

import javax.swing.JCheckBox;


import common.Message;

import client.Client;
import client.OptionsPanel;

public aspect Rot13EncryptionAspect {
	JCheckBox rot13EncyrptionCheckBox = null;
	
	
	after(OptionsPanel op): this(op)  && call(public void setLayout(LayoutManager)) {
		rot13EncyrptionCheckBox = new JCheckBox("rot13 encryption:");
		op.add(rot13EncyrptionCheckBox);
	}
	
	void around(Client c, Message msg): this(c) && execution(public void send(Message)) && args(msg){
	if (rot13EncyrptionCheckBox != null && rot13EncyrptionCheckBox.isSelected()) {
			System.out.println("adding rot13 encyryption");
			String oldHeader = msg.getHeader();
			String newHeader;
			if (oldHeader == null || oldHeader.trim() == "") {
				newHeader =  "rot13";
			} else {
				newHeader = "rot13, " + oldHeader;
			}
			
			msg = new Message(newHeader,alterString(msg.getContent().toLowerCase()));
			System.out.println("rot13 encrypted message: "
					+ msg.getContent());
			System.out
					.println("rot13 encrypted header: " + msg.getHeader());
			//return resultMessage;
		} else {
			System.out.println("not using rot13 encryption");
			//return msg;
		}
	    proceed(c, msg);
	}
	
	private static String alterString(String message) {
		char[] oldContentArray = message.toCharArray();
		for (int i = 0; i < oldContentArray.length; i++) {
			// System.out.println("old char: " + oldContentArray[i]);
			int newValue = oldContentArray[i] + 13;
			if (newValue > 122) {
				newValue = newValue - 26;
			}
			oldContentArray[i] = (char) (newValue);
			// System.out.println("new char: " + oldContentArray[i]);
		}
		System.out.println("trasformed result: " + new String(oldContentArray));
		return new String(oldContentArray);
	}
	
	void around(Client c, Object msg): this(c) && execution(protected void handleIncomingMessage(Object)) && args(msg){
		if (msg instanceof Message){
			Message msg1 = (Message)msg;
		String header = msg1.getHeader();
		int headerPos = header.indexOf("rot13");
		if (headerPos != -1){
	        	System.out.println("rot13 header recieved: " + msg1.getHeader());
	        	System.out.println("rot13 content: "+msg1.getContent());
	        
			
				if (msg1.getHeader().length() > headerPos+7) {
					System.out.println("found rot13 answers");
					header = header.substring(0,headerPos)+header.substring(headerPos+7); 
				}																			
					String content = alterString(msg1.getContent());
					//return (new Message(header, content));
					msg = new Message(header, content);
				}
			  
		}
	        proceed(c,msg);
	}

	 
	
}
