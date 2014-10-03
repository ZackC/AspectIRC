package aspects.filter;

import java.util.HashMap;

import client.Client;
import client.ChatLineListener;

public aspect ProfanityFilterPlugin {

	void around(Client c, ChatLineListener l, String line): this(c) && target(l) 
	&& call(void newChatLine(String)) && args(line){
		proceed(c,l,filterLine(line));
	}
	
	private static final HashMap<String,Boolean> profaneWords = new HashMap<String,Boolean>();
	static {
		profaneWords.put("ass", new Boolean(true));
		profaneWords.put("shit", new Boolean(true));
		profaneWords.put("fuck", new Boolean(true));
		profaneWords.put("dick", new Boolean(true));
	}
	
	
	private String filterLine(String line){
		String[] wordsInLine = line.trim().split("\\s+");
		for(int i = 0; i < wordsInLine.length ; i++){
			if(profaneWords.containsKey(wordsInLine[i])){
				String blockedWord = "";
				for(int j = 0; j < wordsInLine[i].length(); j++){
					blockedWord += "*";
				}
				wordsInLine[i] = blockedWord;
			}
		}
		String resultString = "";
		for(int k = 0; k < wordsInLine.length; k++){
			if(k != wordsInLine.length -1){
			  resultString += wordsInLine[k] + " ";
			}
			else{
				resultString += wordsInLine[k] +"\n";
			}
		}
		return resultString;
	}
	
}
