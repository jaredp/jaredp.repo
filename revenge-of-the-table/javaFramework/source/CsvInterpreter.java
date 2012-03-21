// Michael Vitrano and Jared Pochtar

package rtlib;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.StringTokenizer;


public class CsvInterpreter {

	public static Table toTable(String filename, UserDefinedType type) {
		File file = new File(filename);
		BufferedReader reader;
		
		try{
			 reader = new BufferedReader(new FileReader(file));
		
		Table table = new Table(type);
		String line = null;
		
		int dataTypes[] = type.typeList();
		
		while( (line = reader.readLine())!= null){
			
			StringTokenizer st = new StringTokenizer(line, "," );
			int i = 0;
			Record newRow = new Record(type);
			while(st.hasMoreTokens() && i < dataTypes.length){
				
				try{
				if(dataTypes[i] == Data.BOOL_TYPE){
					newRow.addData(new Data(Boolean.getBoolean(st.nextToken())));
				}
				else if(dataTypes[i] == Data.FLOAT_TYPE){
					newRow.addData(new Data(Double.parseDouble(st.nextToken())));
				}
				else if(dataTypes[i] == Data.INT_TYPE){
					newRow.addData(new Data(Integer.parseInt(st.nextToken())));
				}
				else
					newRow.addData( new Data((st.nextToken())));
				}catch(Exception e){
				     e.printStackTrace();
						return new Table(type);
				}
				
				i++;
			}
			table.addRow(newRow);
		}
		
		return table;
		}catch(Exception e){
			return new Table(type);
		}
	}
	
	public static Table toFile(String filename, Table table) {
		File file = new File(filename);
		FileWriter writer;
		try {
			writer = new FileWriter(file);
			writer.write(table.toFile());
			writer.close();
		}catch(Exception e){
			System.out.println("Bad file: " + filename);
			return null;
		}
		return table;
	}
	
	
	

}
