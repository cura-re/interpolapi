﻿namespace interpolapi.Models
{
	public class Pin
	{
		public int PinId { get; set; }

		public string PinLocation { get; set; }

        public bool IsAnalog { get; set; } = false;

		public string DeviceId { get; set; }

		public Device Device { get; set; }

        public ICollection<Action>? Actions { get; set; }
	}
}

