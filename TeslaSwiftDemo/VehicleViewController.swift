//
//  VehicleViewController.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 22/10/2016.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import UIKit


class VehicleViewController: UIViewController {

	@IBOutlet weak var textView: UITextView!
	var vehicle: Vehicle?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

	@IBAction func getTemps(_ sender: Any) {
		if let vehicle = vehicle {
			_ = api.getVehicleClimateState(vehicle).then {
				(climateState: ClimateState) -> Void in
				self.textView.text = "Inside temp: \(String(describing: climateState.insideTemperature?.celsius))\n" +
					climateState.jsonString!
			}
		}
		
	}
	@IBAction func getChargeState(_ sender: AnyObject) {
		if let vehicle = vehicle {
			_ = api.getVehicleChargeState(vehicle).then {
				(chargeState: ChargeState) -> Void in
				
				self.textView.text = "Battery: \(chargeState.batteryLevel!) % (\(chargeState.idealBatteryRange!.kms) km)\n" +
				"charge rate: \(chargeState.chargeRate!.kms) km/h\n" +
				"energy added: \(chargeState.chargeEnergyAdded!) kWh\n" +
				"distance added (ideal): \(chargeState.chargeDistanceAddedIdeal!.kms) km\n" +
				"power: \(chargeState.chargerPower ?? 0) kW\n" +
				"\(chargeState.chargerVoltage ?? 0)V \(chargeState.chargerActualCurrent!)A\n" +
				"charger max current: \(String(describing: chargeState.chargerPilotCurrent))\n\(chargeState.jsonString!)"
				
				return ()
				}
		}
	}
	@IBAction func getVehicleState(_ sender: Any) {
			if let vehicle = vehicle {
				_ = self.api.getVehicleState(vehicle).then(execute: { (vehicleState: VehicleState) -> Void in
					
					self.textView.text = "FW: \(String(describing: vehicleState.firmwareVersion))\n" +
					vehicleState.jsonString!

				})
		}
		
	}
	@IBAction func getDriveState(_ sender: Any) {
		
		if let vehicle = vehicle {
			_ = api.getVehicleDriveState(vehicle).then {
				(driveState: DriveState) -> Void in
				
				self.textView.text = "Location: \(String(describing: driveState.position))\n" +
					driveState.jsonString!
				
			}
		}
		
	}
	@IBAction func getGUISettings(_ sender: Any) {
		if let vehicle = vehicle {
			_ = api.getVehicleGuiSettings(vehicle).then(execute: { (guiSettings: GuiSettings) -> Void in
				self.textView.text = "Charge rate units: \(String(describing: guiSettings.chargeRateUnits))\n" +
					guiSettings.jsonString!

				
				
			})
		}
		
	}
	
	@IBAction func gettAll(_ sender: Any) {
		if let vehicle = vehicle {
			_ = api.getAllData(vehicle).then(execute: { (extendedVehicle: VehicleExtended) in
				self.textView.text = "All data:\n" +
				extendedVehicle.jsonString!
			})
		}
		
		
	}
	@IBAction func command(_ sender: AnyObject) {
		if let vehicle = vehicle {
			_ = api.sendCommandToVehicle(vehicle, command: .lockDoors).then {
				(response:CommandResponse) -> Void in
				self.textView.text = (response.result! ? "true" : "false")
				if let reason = response.reason {
					self.textView.text.append(reason)
				}
			}
		}
	}
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		
		if segue.identifier == "toStream" {
			
			let vc = segue.destination as! StreamViewController
			vc.vehicle = self.vehicle
		}
	}


}
