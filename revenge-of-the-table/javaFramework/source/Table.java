// Michael Vitrano and Jared Pochtar

package rtlib;

import java.util.ArrayList;
import java.util.Iterator;


public class Table implements Iterable<Record>{
	
    ArrayList<Record> rows;
		UserDefinedType type;
		ArrayList<IteratorHelper> iters;
		int sizes[];
		boolean isTupleTable;
	public Table(UserDefinedType aType){
		type = aType;
		rows = new ArrayList<Record>();
		iters = new ArrayList<IteratorHelper>();
		sizes = new int[type.names.size()];
		for(int i=0; i<type.names.size(); i++)
			sizes[i] = type.names.get(i).length();
	}
    
    public Record first() {
        if (rows.size() > 0) {
            return rows.get(0);
        } else {
            return null;
        }
    }
    
    public Table(Record r){
			type = r.type;
			rows = new ArrayList<Record>();
			iters = new ArrayList<IteratorHelper>();
			sizes = new int[type.names.size()];
			for(int i=0; i<type.names.size(); i++)
				sizes[i] = type.names.get(i).length();
			addRow(r);
	}
	
	public int mySize(){
		return rows.size();
	}
	
	public Iterator<Record> iterator() {
		TableIterator iter = new TableIterator(this);
		iters.add(new IteratorHelper(iter));
		return iter;
		
	}
	
	public Table addRow(Record newRow){
		for(int i = 0; i < newRow.sizes.length; i++){
			if(this.sizes[i]<newRow.sizes[i])
				this.sizes[i] = newRow.sizes[i];
		}
		rows.add(newRow);
		return this;
	}
    
    public Table append(Table other){
		Table newTable = new Table(type);
		for(Record row : this ){
			newTable.addRow(row);
		}
		for(Record row : other ){
			newTable.addRow(row);
		}
		return newTable;
	}
	
	public void delete(Record a){
		int i = rows.indexOf(a);
		if( i != -1){
			rows.remove(i);
			for(IteratorHelper help : iters){
				if(i < help.getLoc()){
					help.getIter().decLoc();
				}
			}
		}
	}
	
	public void deleteIter(TableIterator iter){
		Iterator<IteratorHelper> arrayIter = iters.iterator();
		while(arrayIter.hasNext()){
			IteratorHelper next = arrayIter.next();
			if(next.getIter() == iter)
				arrayIter.remove();
		}
	}
	
	public Table tail(){
		if(rows.size() > 1){
			Table ret = new Table(type);
			for(int i = 1; i < rows.size(); i++){
				ret.addRow(rows.get(i));
			}
			return ret;
		}else
			return null;
	}
	
	
	public Table copyOf(){
		Table newTable = new Table(type);
		for(Record row : rows)
			newTable.addRow(row.copyOf());
		return newTable;
	}
    
	public Table prepend(Record r) {
		Table newTable = new Table(type);
		newTable.addRow(r);
		for(Record row : this){
			newTable.addRow(row);
		}
		return newTable;
 	}
	
	public String toString(){
		String out = type.toString(sizes) + "\n";
		for(int i = 0; i < rows.size(); i++){
			if( i != rows.size() - 1)
				out += rows.get(i).toString(sizes) + "\n";
			else 
				out += rows.get(i).toString(sizes) ;
		}
		return out;
	}
	
    public String toFile(){
    String out = "";
		for(int i = 0; i < rows.size(); i++){
			if(i != rows.size() -1 )
				out += rows.get(i).toFile() + "\n";
			else
				out += rows.get(i).toFile();
		}
		return out;
	}
	
	public ArrayList<Record> getRows(){return rows;}
	
	public UserDefinedType getType(){
		return type;
	}
	
	public Table filter(FilterPredicate pred){
		Table newTable = new Table(type);
		for(Record row : rows){
			if(pred.test(row))
				newTable.addRow(row);
		}
		return newTable;
	}
	
	public Table filterMap(FilterMap map){
		Table newTable = new Table(map.getType());
		for(Record row : rows){
			Record toAdd = map.map(row);
			if(toAdd != null)
				newTable.addRow(toAdd);
		}
		return newTable;
	}
	
	public Table joinMap(Table rhs, JoinMap map){
        UserDefinedType newType = UserDefinedType.combineTypes(this.type, rhs.type);
        int sizeof_a = this.type.types.size();
        int sizeof_b = rhs.type.types.size();
        
		Table newTable = new Table(map.getType());
        
		for(Record thisRow : this.rows){
			for(Record rhsRow : rhs.rows){
                Record newRec = new Record(newType);
				
                for(int k = 0; k < sizeof_a; k++){
                    newRec.addData(thisRow.getData(k));
                }
                
                for(int k = 0; k <  sizeof_b; k++){
                    newRec.addData(rhsRow.getData(k));
                }

				Record toAdd = map.map(newRec, thisRow, rhsRow);
                if(toAdd != null) {
					newTable.addRow(toAdd);
                }
            }
		}
		return newTable;
	}
	
	public Table join(Table rhs, JoinPredicate pred){
		UserDefinedType newType = UserDefinedType.combineTypes(this.type, rhs.type);
        int sizeof_a = this.type.types.size();
        int sizeof_b = rhs.type.types.size();
		
		Table newTable = new Table(newType);
        
        for (Record a : this) {
            for (Record b : rhs) {
                Record newRec = new Record(newType);
				
                for(int k = 0; k < sizeof_a; k++){
                    newRec.addData(a.getData(k));
                }
                
                for(int k = 0; k <  sizeof_b; k++){
                    newRec.addData(b.getData(k));
                }
                
                if (pred.test(newRec, a, b)) {
                    newTable.addRow(newRec);
                }
            }
        }
		
        return newTable;
	}
	
	public Table getReg(UserDefinedType t){
		@SuppressWarnings("unchecked")
		TupleType tType = (TupleType) type;
		int bounds[] = tType.getTypeBounds(t);
		Table ret = new Table(t);
		//System.out.println("bounds are " + bounds[0] + " and " + bounds[1]);
		for(Record toAdd : rows){
			Record newRec = new Record(t);
			for(int i = bounds[0]; i < bounds[1]; i++)
				newRec.addData(toAdd.entries[i]);
			ret.addRow(newRec);
		}
		return ret;
	}
	
	private class TableIterator implements Iterator<Record>{
		private Table t;
		int i;
		public TableIterator(Table aTable){
			t = aTable;
			i = 0;
		}
		public boolean hasNext(){
			boolean next = i < t.rows.size();
			if(next)
				return true;
			else{
				t.deleteIter(this);
				return false;
			}		
		}
		public Record next(){
			i++;
			return t.rows.get(i-1);
		}
		
		public void decLoc(){i--;}
		
		public void remove () {}	
		public int getLoc(){return i;}
	}
	
	private class IteratorHelper{
		private TableIterator iter;
		
		public IteratorHelper(TableIterator aIter){
			iter = aIter;
		}
		public int getLoc(){return iter.getLoc();}
		
		public TableIterator getIter(){return iter;}
		
	}
	
}