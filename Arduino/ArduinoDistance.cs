using Godot;
using System;
using System.IO.Ports;

public partial class ArduinoDistance : Node2D
{
	private SerialPort serialPort;
	private float distancia;

	// Propiedad exportable para que otros nodos puedan acceder a la distancia
	public float Distancia => distancia;

	public override void _Ready()
	{
		// Configura el puerto serial
		serialPort = new SerialPort();
		serialPort.PortName = "COM3"; // Cambia esto si el puerto es diferente
		serialPort.BaudRate = 9600; // Asegúrate de que coincide con la configuración del Arduino
		serialPort.ReadTimeout = 100;

		try
		{
			serialPort.Open(); // Abre el puerto
			GD.Print("Puerto serial abierto correctamente.");
		}
		catch (Exception e)
		{
			GD.PrintErr($"Error al abrir el puerto serial: {e.Message}");
		}
	}

	public override void _Process(double delta)
	{
		if (!serialPort.IsOpen)
			return;

		try
		{
			string serialMessage = serialPort.ReadLine();

			if (float.TryParse(serialMessage, out float distanciaLeida))
			{
				distancia = distanciaLeida; // Actualiza la distancia
				//GD.Print($"Distancia leída: {distancia}"); // Imprime la distancia para depuración
			}
		}
		catch (TimeoutException)
		{
			// Ignora si no hay datos disponibles
		}
		catch (Exception e)
		{
			GD.PrintErr($"Error en la comunicación serial: {e.Message}");
		}
	}

	public override void _ExitTree()
	{
		if (serialPort != null && serialPort.IsOpen)
		{
			serialPort.Close();
		}
	}
}
