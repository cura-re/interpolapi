using System;
using System.Collections.Generic;
using System.IO.Ports;

namespace interpolapi.Devices;

public class Devicer {
    SerialPort serialPort;
    public string DeviceId { get; set; } = null!;
    public string DeviceName { get; set; } = null!;
    public string DeviceType { get; set; } = null!;
    public string DeviceModel { get; set; } = null!;
    public string DeviceBrand { get; set; } = null!;
    public string DeviceSerialNumber { get; set; } = null!;
    public string DeviceOwner { get; set; } = null!;
    public string DeviceLocation { get; set; } = null!;
    public string DeviceStatus { get; set; } = null!;
    public string DeviceCondition { get; set; } = null!;
    private DateTimeOffset? _lastUpdatedAt;
    public IReadOnlyDictionary<string, string> DeviceMetadata { get; set; } = new Dictionary<string, string>();
    public IReadOnlyDictionary<string, string> DeviceHistory { get; set; } = new Dictionary<string, string>();
    public IReadOnlyDictionary<string, string> DeviceErrors { get; set; } = new Dictionary<string, string>();
    
    public Devicer(string deviceId, string deviceName, string deviceType, string deviceModel, string deviceBrand, string deviceSerialNumber, string deviceOwner, string deviceLocation, string deviceStatus, string deviceCondition, IReadOnlyDictionary<string, string> deviceMetadata, IReadOnlyDictionary<string, string> deviceHistory, IReadOnlyDictionary<string, string> deviceErrors)
    {
        DeviceId = deviceId;
        DeviceName = deviceName;
        DeviceType = deviceType;
        DeviceModel = deviceModel;
        DeviceBrand = deviceBrand;
        DeviceSerialNumber = deviceSerialNumber;
        DeviceOwner = deviceOwner;
        DeviceLocation = deviceLocation;
        DeviceStatus = deviceStatus;
        DeviceCondition = deviceCondition;
        DeviceMetadata = deviceMetadata;
        DeviceHistory = deviceHistory;
        DeviceErrors = deviceErrors;
        _lastUpdatedAt = DateTimeOffset.Now;
        serialPort = new SerialPort("/dev/cu.usbmodemDC5475C4CA802", 9600);
        try {
            serialPort.Open();
        } catch (Exception e) {
            Console.WriteLine(e.Message);
        }
    }
    public void TurnOn(string command)
    {
        Console.Write("Turning on device: " + DeviceName + " with command: " + command + "\n" + serialPort);
        serialPort.WriteLine(command);
        _lastUpdatedAt = DateTimeOffset.Now;
    }
    public void Dispose()
    {
        serialPort.Close();
        serialPort.Dispose();
    }
    public DateTimeOffset? LastUpdatedAt
    {
        get => _lastUpdatedAt;
        set => _lastUpdatedAt = value ?? DateTimeOffset.Now;
    }
    // Methods for the API to call
    internal void UpdateDeviceInfo(string device) {
        // Update the device information
    }
    internal bool SetDeviceError (string error) {
        // Set the device error
        return true;
    }
    internal bool ClearDeviceError (string error) {
        // Clear the device error
        return true;
    }
    internal void UpdateDeviceHistory (string history) {
        // Update the device history
    }
    
    // Additional properties for the API
    public bool IsOnline { get; set; }
    public int BatteryLevel { get; set; }
    public float Temperature { get; set; }
}