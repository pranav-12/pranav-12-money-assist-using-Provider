public static void main(String[] args) {
    
}

public class SLinkedlist{
    class Node{
        int data;
        Node next;
        Node(int data){
            this.data=data;
        }
    }

    public Node head=null;
    public Node tail=null;
    public void addNode(int data){
Node newNode=new Node(data);
if (head==null) {
    head=newNode;
} else {
    tail.next=newNode;
}
tail=newNode;
    }
}