package application.labos_IoT;

import com.digi.xbee.api.XBeeDevice;
import com.digi.xbee.api.exceptions.XBeeException;

public class XBeeGateway {
	private static final String PORT = "COM4";  //imam dva com4 ili com5
	private static final int BAUD_RATE = 115200;

	
	public static void main(String[] args) {
		System.out.println(" +-----------------------------------------+");
		System.out.println(" |  XBee Java Library Receive Data Sample  |");
		System.out.println(" +-----------------------------------------+\n");
		
		XBeeDevice _myDevice = new XBeeDevice(PORT, BAUD_RATE);
		
		try {
			_myDevice.open();
			
			MyDataReceiveListener l = new MyDataReceiveListener();
			
			l.setXBeeDevice(_myDevice);
			
			_myDevice.addDataListener(l);				
						
			System.out.println("\n>> Waiting for data...");
			
		} catch (XBeeException e) {
			e.printStackTrace();
			System.exit(1);
		}
	}
}
