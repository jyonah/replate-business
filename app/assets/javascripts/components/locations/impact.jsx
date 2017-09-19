/**
 * @prop location_id
 */

 class Impact extends React.Component {
   constructor(props) {
     super(props);
     this.state = {
       tasks: [],
      //  showModal: false;
      };
   }

   _setTotalPounds = () => {
     let lbs = 0;
     this.state.tasks.forEach((task) => {
      let regex = /(^\d+),/.exec(task.description)
      if (regex) {
        lbs += parseInt(regex[0])
      }
     })
     return lbs
   }

   _showImpactData = (pounds, metricType) => {
     if (metricType == "meals") {
       return <ImpactMetric metricValue={this._calculateMeals(pounds)} metricUnit="meals" subText="fed to the hungry"/>
     } else if (metricType == "water") {
       return <ImpactMetric metricValue={this._calculateWater(pounds)} metricUnit="gallons" subText="of water saved"/>
     } else if (metricType == "CO2") {
       return <ImpactMetric metricValue={this._calculateCO2(pounds)} metricUnit="pounds" subText="of C02 diverted"/>
     } else if (metricType == "pounds") {
       return <ImpactMetric metricValue={pounds} metricUnit="pounds" subText="of food donated"/>
     }
   }

   _renderAllData = () => {
     let metricTypes = ["pounds", "meals", "water", "CO2"]
     let renderData = []
     let pounds = this._setTotalPounds()

     metricTypes.forEach((metricType) => {
       renderData.push(this._showImpactData(pounds, metricType))
     })
     return renderData
   }

   _renderSocialData = () => {
     let metricTypes = ["pounds", "meals"]
     let renderData = []
     let pounds = this._setTotalPounds()

     metricTypes.forEach((metricType) => {
       renderData.push(this._showImpactData(pounds, metricType))
     })
     return renderData
   }

   _renderEnvData = () => {
     let metricTypes = ["water", "CO2"]
     let renderData = []
     let pounds = this._setTotalPounds()

     metricTypes.forEach((metricType) => {
       renderData.push(this._showImpactData(pounds, metricType))
     })
     return renderData

   }

  //  let renderData = _renderAllData()

  //  Calculation Functions

  _calculateMeals = (pounds) => {
    return Math.floor(pounds / 1.2)
  }
  _calculateWater = (pounds) => {
    return Math.floor(pounds * 277)
  }
  _calculateCO2 = (pounds) => {
    return Math.floor(pounds * 13.77)
  }



   componentWillReceiveProps(nextProps) {
     this.state.tasks = nextProps.tasks;
   }


   close = (e) => {
     var initial = this.state.initialState;
     this.state = initial;
     this.setState({initialState: initial});
     this.setState({ showModal: false });
     document.getElementById('map').innerHTML = '';

   }

   openModal = () => {
     this.setState({ showModal: true });
   }

   render() {
       let empty;
      //  let renderData = this._renderAllData()
      let socialData = this._renderSocialData();
      let envData = this._renderEnvData();
       if (this.state.tasks.length == 0) {
         empty = (
           <div className="empty-table-container">
             <h1>Nothing donated yet!</h1>
           </div>
         );
       }
       const tasks = this.state.tasks.map((item, index) => {
        //  return (
        //   //  <ImpactData item = {item}
        //   //              key  = {index} />
        //  );
       });

       return (
         <div className="impact-content">
           {empty}
           {/* <ImpactMetric metricValue="42" metricUnit="lbs" subText="of food donated."/> */}
           <div className="social-data flex-container">
             {socialData}
           </div>
           <div className="env-data flex-container">
             {envData}
           </div>
         </div>
       );
     }
   }


 /**
  * History Item component
  * @prop item - details of item
  */
//  class ImpactData extends React.Component {
//    render() {
//      let scheduled_date = moment(this.props.item.scheduled_date).format('MMMM Do YYYY, h:mm a');
//       return (
//          <tr className="table-row impact-row">
//            <td className="tasks-date-col">
//              { scheduled_date }
//            </td>
//            <td className="driver-id-col">
//              { this.props.item.driver }
//            </td>
//            <td>
//              { this.props.item.trays_donated }
//            </td>
//
//            <td>
//
//            </td>
//        </tr>
//    );
//  }
// }

Impact.propTypes = {
  location_id: React.PropTypes.number.isRequired,
}
