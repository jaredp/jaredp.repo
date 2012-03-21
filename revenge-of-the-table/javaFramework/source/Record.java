// Michael Vitrano and Jared Pochtar

package rtlib;

import java.util.Iterator;


public class Record extends Table implements Iterable<Record> {

	public Data[] entries;
	private int next;
    UserDefinedType type;
	int sizes[];
	public Record(UserDefinedType aType){
		super(aType);
		type = aType;
		entries = new Data[type.getSize()];
		next = 0;
		sizes = new int[type.names.size()];
	}
	
	public Record(UserDefinedType aType, Data ... dataMembers){
		super(aType);
		type = aType;
		entries = new Data[type.getSize()];
		next = 0;
		sizes = new int[type.names.size()];
		for(int i = 0; i < dataMembers.length; i++){
			entries[i] = dataMembers[i];
			sizes[i] = dataMembers[i].toString().length();
			next++;
		}
		
	}
	
	public Record copyOf(){
		Record copy = new Record(type);
		for(int i = 0; i < entries.length; i++)
			copy.addData(entries[i].copyOf());
		return copy;
	}
	
	public Table addRow(Record newRow){
        return null;
    }
	
	public Iterator<Record> iterator() {
		return this.new RecordIterator(this);
	}
	
	public void addData(Data newData){
		entries[next] = newData;
		sizes[next] = newData.toString().length();
		next++;
	}
	
	public Data getData(int i){
		return entries[i];
	}
	
	public void SetData(int i, Data d){
		entries[i] = d;
	}
	
	public String toString(){
		String out = "| ";
		for(int i = 0; i < entries.length; i++){
            out += entries[i] + "\t| ";
		}
		return out;
	}
	
	public String toString(int[] size){
		String out = "| ";
		for(int i = 0; i < entries.length; i++){
			String str = entries[i].toString();
			int frontPad, backPad;
			if(str.length() < size[i]){
				frontPad = (int)Math.floor((size[i]-str.length())/2.0);
				backPad = size[i]-str.length() - frontPad;
			}else{
				frontPad = 0;
				backPad = 0;
			}
			for(int j = 0; j < frontPad; j++)
				out += " ";
			out += str;
			for(int j = 0; j < backPad; j++)
				out += " ";
			out += " | ";
		}
		return out;
	}
	
	public int mySize(){return 1;}
	
	public int size(){return entries.length; }
	
	public String toFile(){
		String out = "";
		for(int i = 0; i < entries.length; i++){
       	   if( i != entries.length - 1 )
              out += entries[i] + ",";
            else
              out += entries[i];
		}
		return out;
	}
	
	private class RecordIterator implements Iterator<Record>{
		private boolean next = true;
		private Record data;
		public RecordIterator(Record aData){
			data = aData;
		}
		public boolean hasNext(){
			return next;
		}
		public Record next() {
			next = false;
			return data;
		}
		public void remove() {		}
	}
}
