// Michael Vitrano and Jared Pochtar

package rtlib;

public interface JoinPredicate {
    boolean test(Record record, Record a, Record b);
}
