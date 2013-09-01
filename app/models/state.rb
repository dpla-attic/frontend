class State
  attr_reader :abbr, :name, :lat, :lng

  LIST = {
    'Alaska' => { abbr: 'AK', name: 'Alaska', lat: 61.3850, lng: -152.2683 },
    'Alabama' => { abbr: 'AL', name: 'Alabama', lat: 32.7990, lng: -86.8073 },
    'Arkansas' => { abbr: 'AR', name: 'Arkansas', lat: 34.9513, lng: -92.3809 },
    'American Samoa' => { abbr: 'AS', name: 'American Samoa', lat: 14.2417, lng: -170.7197 },
    'Arizona' => { abbr: 'AZ', name: 'Arizona', lat: 33.7712, lng: -111.3877 },
    'California' => { abbr: 'CA', name: 'California', lat: 36.1700, lng: -119.7462 },
    'Colorado' => { abbr: 'CO', name: 'Colorado', lat: 39.0646, lng: -105.3272 },
    'Connecticut' => { abbr: 'CT', name: 'Connecticut', lat: 41.5834, lng: -72.7622 },
    'District of Columbia' => { abbr: 'DC', name: 'District of Columbia', lat: 38.8964, lng: -77.0262 },
    'Delaware' => { abbr: 'DE', name: 'Delaware', lat: 39.3498, lng: -75.5148 },
    'Florida' => { abbr: 'FL', name: 'Florida', lat: 27.8333, lng: -81.7170 },
    'Georgia' => { abbr: 'GA', name: 'Georgia', lat: 32.9866, lng: -83.6487 },
    'Hawaii' => { abbr: 'HI', name: 'Hawaii', lat: 21.1098, lng: -157.5311 },
    'Iowa' => { abbr: 'IA', name: 'Iowa', lat: 42.0046, lng: -93.2140 },
    'Idaho' => { abbr: 'ID', name: 'Idaho', lat: 44.2394, lng: -114.5103 },
    'Illinois' => { abbr: 'IL', name: 'Illinois', lat: 40.3363, lng: -89.0022 },
    'Indiana' => { abbr: 'IN', name: 'Indiana', lat: 39.8647, lng: -86.2604 },
    'Kansas' => { abbr: 'KS', name: 'Kansas', lat: 38.5111, lng: -96.8005 },
    'Kentucky' => { abbr: 'KY', name: 'Kentucky', lat: 37.6690, lng: -84.6514 },
    'Louisiana' => { abbr: 'LA', name: 'Louisiana', lat: 31.1801, lng: -91.8749 },
    'Massachusetts' => { abbr: 'MA', name: 'Massachusetts', lat: 42.2373, lng: -71.5314 },
    'Maryland' => { abbr: 'MD', name: 'Maryland', lat: 39.0724, lng: -76.7902 },
    'Maine' => { abbr: 'ME', name: 'Maine', lat: 44.6074, lng: -69.3977 },
    'Michigan' => { abbr: 'MI', name: 'Michigan', lat: 43.3504, lng: -84.5603 },
    'Minnesota' => { abbr: 'MN', name: 'Minnesota', lat: 45.7326, lng: -93.9196 },
    'Missouri' => { abbr: 'MO', name: 'Missouri', lat: 38.4623, lng: -92.3020 },
    'Northern Mariana Islands' => { abbr: 'MP', name: 'Northern Mariana Islands', lat: 14.8058, lng: 145.5505 },
    'Mississippi' => { abbr: 'MS', name: 'Mississippi', lat: 32.7673, lng: -89.6812 },
    'Montana' => { abbr: 'MT', name: 'Montana', lat: 46.9048, lng: -110.3261 },
    'North Carolina' => { abbr: 'NC', name: 'North Carolina', lat: 35.6411, lng: -79.8431 },
    'North Dakota' => { abbr: 'ND', name: 'North Dakota', lat: 47.5362, lng: -99.7930 },
    'Nebraska' => { abbr: 'NE', name: 'Nebraska', lat: 41.1289, lng: -98.2883 },
    'New Hampshire' => { abbr: 'NH', name: 'New Hampshire', lat: 43.4108, lng: -71.5653 },
    'New Jersey' => { abbr: 'NJ', name: 'New Jersey', lat: 40.3140, lng: -74.5089 },
    'New Mexico' => { abbr: 'NM', name: 'New Mexico', lat: 34.8375, lng: -106.2371 },
    'Nevada' => { abbr: 'NV', name: 'Nevada', lat: 38.4199, lng: -117.1219 },
    'New York' => { abbr: 'NY', name: 'New York', lat: 42.1497, lng: -74.9384 },
    'Ohio' => { abbr: 'OH', name: 'Ohio', lat: 40.3736, lng: -82.7755 },
    'Oklahoma' => { abbr: 'OK', name: 'Oklahoma', lat: 35.5376, lng: -96.9247 },
    'Oregon' => { abbr: 'OR', name: 'Oregon', lat: 44.5672, lng: -122.1269 },
    'Pennsylvania' => { abbr: 'PA', name: 'Pennsylvania', lat: 40.5773, lng: -77.2640 },
    'Puerto Rico' => { abbr: 'PR', name: 'Puerto Rico', lat: 18.2766, lng: -66.3350 },
    'Rhode Island' => { abbr: 'RI', name: 'Rhode Island', lat: 41.6772, lng: -71.5101 },
    'South Carolina' => { abbr: 'SC', name: 'South Carolina', lat: 33.8191, lng: -80.9066 },
    'South Dakota' => { abbr: 'SD', name: 'South Dakota', lat: 44.2853, lng: -99.4632 },
    'Tennessee' => { abbr: 'TN', name: 'Tennessee', lat: 35.7449, lng: -86.7489 },
    'Texas' => { abbr: 'TX', name: 'Texas', lat: 31.1060, lng: -97.6475 },
    'Utah' => { abbr: 'UT', name: 'Utah', lat: 40.1135, lng: -111.8535 },
    'Virginia' => { abbr: 'VA', name: 'Virginia', lat: 37.7680, lng: -78.2057 },
    'Virgin Islands' => { abbr: 'VI', name: 'Virgin Islands', lat: 18.0001, lng: -64.8199 },
    'Vermont' => { abbr: 'VT', name: 'Vermont', lat: 44.0407, lng: -72.7093 },
    'Washington' => { abbr: 'WA', name: 'Washington', lat: 47.3917, lng: -121.5708 },
    'Wisconsin' => { abbr: 'WI', name: 'Wisconsin', lat: 44.2563, lng: -89.6385 },
    'West Virginia' => { abbr: 'WV', name: 'West Virginia', lat: 38.4680, lng: -80.9696 },
    'Wyoming' => { abbr: 'WY', name: 'Wyoming', lat: 42.7475, lng: -107.2085 }
  }

  def initialize(state)
    @abbr, @name, @lat, @lng = state[:abbr], state[:name], state[:lat], state[:lng]
  end

  def self.geocode(name)
    if state = find_by_name(name)
      [state.lat, state.lng]
    end
  end

  def self.find_by_name(name)
    state = LIST.select { |k| k =~ Regexp.new("^#{name}$", true) }.to_a.first
    if state
      self.new state.last
    end
  end

  def self.state_in_list?(state)
    LIST.has_key? state
  end
end
