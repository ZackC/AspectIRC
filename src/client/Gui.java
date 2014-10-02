package client;

import java.awt.BorderLayout;
import java.awt.Event;
import java.awt.Frame;
import java.awt.TextArea;
import java.awt.TextField;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;

import client.OptionsPanel;

/**
 * simple AWT gui for the chat client
 */
public class Gui extends Frame implements ChatLineListener {

	private static final long serialVersionUID = 1L;

	protected TextArea outputTextbox;

	protected TextField inputField;

	private final Client chatClient;

	private final OptionsPanel optionFrame;

	/**
	 * creates layout
	 * 
	 * @param title
	 *            title of the window
	 * @param chatClient
	 *            chatClient that is used for sending and receiving messages
	 */
	public Gui(String title, final Client chatClient) {
		super(title);
		System.out.println("starting gui...");
		setLayout(new BorderLayout());
		outputTextbox = new TextArea();
		add("Center", outputTextbox);
		outputTextbox.setEditable(false);
		inputField = new TextField();
		inputField.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent evt) {
				if (evt.getKeyCode() == KeyEvent.VK_ENTER) {
					if (!inputField.getText().trim().equals("")) {
						chatClient.send(inputField.getText());
						inputField.setText("");
					}
				}
			}
		});
		add("South", inputField);
		optionFrame = new OptionsPanel(this);
		add("East", optionFrame);

		// register listener so that we are informed whenever a new chat message
		// is received (observer pattern)
		chatClient.addLineListener(this);

		pack();
		setVisible(true);
		inputField.requestFocus();

		this.chatClient = chatClient;
	}

	public TextArea getTextArea() {
		return outputTextbox;
	}

	/**
	 * this method gets called every time a new message is received (observer
	 * pattern)
	 */
	@Override
	public void newChatLine(String line) {
		outputTextbox.append(line);
	}

	/**
	 * handles AWT events (enter in textfield and closing window)
	 */
	@Override
	public boolean handleEvent(Event e) {
		// if ((e.target == inputField) && (e.id == Event.ACTION_EVENT)) {
		// chatClient.send((String) e.arg);
		// inputField.setText("");
		// return true;
		// } else
		if ((e.target == this) && (e.id == Event.WINDOW_DESTROY)) {
			if (chatClient != null)
				chatClient.stop();
			setVisible(false);
			System.exit(0);
			return true;
		}
		return super.handleEvent(e);
	}
}
