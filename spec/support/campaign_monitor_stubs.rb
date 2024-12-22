module CampaignMonitorStubs
  def self.configure
    WebMock
      .stub_request(:get, %r{https://api.createsend.com/api/v3.3/subscribers/(camp-key|conf-key|girls-key).json})
      .to_return(
        status: 200,
        body: { State: "Active" }.to_json,
        headers: { 'Content-Type': 'application/json' }
      )
  end
end
