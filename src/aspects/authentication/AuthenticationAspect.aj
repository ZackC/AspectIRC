package aspects.authentication;

import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.util.HashSet;

import javax.swing.BoxLayout;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;

import client.Client;

import server.Connection;
import server.Server;
import common.Message;
import java.net.ServerSocket;



//public class AutheticationAspect{
 public privileged aspect AuthenticationAspect {
	
	 private String password = null;
	 

	 private HashSet<Connection> autheticatedConnections = new HashSet<Connection>();
	 
	
	 
	/*after (): synchronizationPoint() {
		this.guardedExit(thisJoinPointStaticPart.getSignature().getName());
	    }*/
	  
	 
 
	
	pointcut mainMethod() : execution(public static void main(String[]));
	
/*	after(): initialization(ServerSocket+){
		System.out.println("hi how are you");
	}*/ 
	
	/*before() : mainMethod() && this(Server){
		System.out.println("hi how are you");
	}*/
  
	after(final Server server): call(ServerSocket.new(int)) && this(server){
  	JFrame frame = new JFrame("Enter Client Password");
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.getContentPane().setLayout(new FlowLayout());
		frame.getContentPane().add(new JLabel("Enter Client's password"));
		final JTextField passwordField = new JTextField();
		passwordField.setPreferredSize(new Dimension(100, 30));
		
		frame.getContentPane().add(passwordField);
		passwordField.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent evt) {
				if (evt.getKeyCode() == KeyEvent.VK_ENTER) {
					if (!passwordField.getText().trim().equals("")) {
						password = (passwordField.getText());
						passwordField.setText("");
					}
				}
			}
		});
		frame.setSize(300, 40);
		frame.pack();
		frame.setVisible(true);
		while (password == null) {
			try {
				Thread.sleep(500);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		frame.setVisible(false);
		frame.dispose();
  }
	
	
	void around(Connection connection, String s, Object msg): this(connection) && execution(private void handleIncomingMessage(String, Object)) && args(s,msg){
		if (msg instanceof Message){
			Message msg1 = (Message)msg;
		System.out.println("authetication header: "+msg1.getHeader());
		if (msg1.getHeader().equals("authentication")) {
			System.out.println("check 2:");
			if (msg1.getContent().equals(password)) {
				System.out.println("check 3");
				autheticatedConnections.add(connection);
				System.out.println("authenticated client");
				connection.send(new Message("authentication", "valid"));
				System.out.println("Server sent confirmation message");
				msg = null;
			} else {
				connection.send(new Message("authentication", "notvalid"));
				msg =  null;
			}
		}

      }
	proceed(connection,s,msg);
		
	}
	
	before(Server s) : this(s) && execution(public void broadcast(Message)){
		s.connections = autheticatedConnections;
	}
	
	
	before(Client c): this(c) && target(Thread) && call(void start()){
		JFrame frame = new JFrame("Login Frame");
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.getContentPane().setLayout(
				new BoxLayout(frame.getContentPane(), BoxLayout.PAGE_AXIS));
		JPanel usernamePanel = new JPanel();
		usernamePanel.setLayout(new FlowLayout());
		usernamePanel.add(new JLabel("Enter username: "));
		final JTextField userNameField = new JTextField();
		userNameField.setPreferredSize(new Dimension(150, 30));
		usernamePanel.add(userNameField);
		frame.add(usernamePanel);
		JPanel passwordPanel = new JPanel();
		passwordPanel.setLayout(new FlowLayout());
		passwordPanel.add(new JLabel("Enter Server's password"));
		final JTextField checkPasswordField = new JTextField();
		checkPasswordField.setPreferredSize(new Dimension(150, 30));
		passwordPanel.add(checkPasswordField);
		checkPasswordField.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent evt) {
				if (evt.getKeyCode() == KeyEvent.VK_ENTER) {
					if (!checkPasswordField.getText().trim().equals("")
							&& !userNameField.getText().trim().equals("")) {
						System.out.println("client entered a possible password");
						password = checkPasswordField.getText();
						checkPasswordField.setText("");
					}
				}
			}
		});
		frame.add(passwordPanel);
		frame.pack();
		frame.setVisible(true);
		boolean correctPassword = false;
		while (!correctPassword) {
			while (password == null) {
				try {
					Thread.sleep(500);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			System.out.println("the entered password is: " + password);
			// need to send this to the server and have it check for users
			c.send(new Message("authentication", password));
			System.out.println("sent message");
			Object msg = null;
			while (msg == null) {
				try {
					msg = c.inputStream.readObject();
					System.out.println("received response");
				} catch (Exception e) {
				}
				if (msg == null) {
					try {
						Thread.sleep(500);
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
			System.out.println(msg instanceof Message);
			System.out
					.println(((Message) msg).getHeader().equals("authentication"));
			System.out.println(((Message) msg).getContent().trim().equals("valid"));
			System.out.println(((Message) msg).getHeader());
			System.out.println(((Message) msg).getContent());
			if ((msg instanceof Message)
					&& ((Message) msg).getHeader().equals("authentication")) {
				if (((Message) msg).getContent().trim().equals("valid")) {
					correctPassword = true;
					System.out.println("was authenticated by server");
					frame.setVisible(false);
					frame.dispose();
				} else {

					password = null;
				}
			} else {
				msg = null;
			}
		}

	}
	
	

}
