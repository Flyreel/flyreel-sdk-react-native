import * as React from 'react';
import {
  StyleSheet,
  View,
  Text,
  TouchableOpacity,
  NativeModules,
} from 'react-native';
const { Flyreel } = NativeModules;

export default function App() {
  React.useEffect(() => {
    Flyreel.initialize('OrganizationID', 1);
    Flyreel.enableLogs();
  }, []);

  return (
    <View style={styles.container}>
      <TouchableOpacity style={styles.button} onPress={() => Flyreel.open()}>
        <Text style={styles.buttonText}>Open Flyreel</Text>
      </TouchableOpacity>
      <TouchableOpacity
        style={styles.button}
        onPress={() =>
          Flyreel.openWithDeeplink(
            'https://your.custom.url/?flyreelAccessCode=6M4T0T&flyreelZipCode=80212',
            true
          )
        }
      >
        <Text style={styles.buttonText}>Open Flyreel with URL</Text>
      </TouchableOpacity>
      <TouchableOpacity
        style={styles.button}
        onPress={() => Flyreel.openWithCredentials('80212', '6M4T0T', true)}
      >
        <Text style={styles.buttonText}>Open Flyreel with credentials</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
  button: {
    backgroundColor: '#3498db',
    borderRadius: 20,
    paddingVertical: 15,
    paddingHorizontal: 20,
    marginBottom: 20,
  },
  buttonText: {
    color: '#ffffff',
    fontSize: 16,
    fontWeight: 'bold',
  },
});
