class ImpactMetric extends React.Component {
  constructor(props){
    super(props){
      this.state = {
        metricValue: 0,
        metricUnit: "",
        subText: "",
      };
    }
  }

  render() {
    <div className="impact-metric">
      <span className="metric-value">{this.state.metricValue}</span>
      <span className="metric-unit">{this.state.metricUnit}</span>
      <span className="subtext">{this.state.subText}</span>
    </div>
  }
}
