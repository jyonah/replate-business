class ImpactMetric extends React.Component {

  render() {
    return (
      <div className="impact-metric">
        <span className="metric-value">{this.props.metricValue} </span>
        <span className="metric-unit">{this.props.metricUnit} </span>
        <span className="subtext">{this.props.subText} </span>
      </div>
    )
  }
}
