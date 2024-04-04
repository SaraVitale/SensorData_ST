import SwiftUI
import CoreML

struct SensorProperties {
    var `Type`: String
    var Temperature: Double
    var Volt: Double
    var Pressure: Double
}

// Pagina principale
struct SensorDataView: View {
    // Array di esempio di dati del sensore
    @State private var sensorDataArray: [SensorProperties] = [
        SensorProperties(Type: "", Temperature: 63.14, Volt: 2.993, Pressure: 28.92),
        SensorProperties(Type: "B", Temperature: 140.8, Volt: 4.29, Pressure: -19.73)
      
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(sensorDataArray.indices, id: \.self) { index in
                    SensorDataRow(sensorData: $sensorDataArray[index])
                }
            }
            .navigationTitle("Sensor Data")
            .tabItem { // Aggiunto tabItem con titolo
                Text("Sensor Data")
            }
        }
    }
}

struct SensorDataRow: View {
    @Binding var sensorData: SensorProperties
    @State private var wearStatus: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Type")
                TextField("", text: $sensorData.Type)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            HStack {
                Text("Temperature(°C)")
                TextField("", value: $sensorData.Temperature, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            HStack {
                Text("Voltage(V)")
                TextField("Volt", value: $sensorData.Volt, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            HStack{
                Text("Pressure(Pa)")
                TextField("Pressure", value: $sensorData.Pressure, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())}
            
                Text("Wear Status: \(wearStatus)")
                Button("Update", action: predictWearStatus)
            }

        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(.vertical, 5)
    }

   
    func predictWearStatus() {
        do {
            let model = SensorDataST_1()
            let prediction = try model.prediction(Type_: sensorData.Type,
                                                Temperature: sensorData.Temperature,
                                                  Volt: sensorData.Volt,
                                                  Pressure: sensorData.Pressure)
            wearStatus = prediction.class_type
        } catch {
            wearStatus = "Prediction Error"
        }
    }
}

// Preview
struct SensorDataView_Previews: PreviewProvider {
    static var previews: some View {
        SensorDataView()
    }
}

