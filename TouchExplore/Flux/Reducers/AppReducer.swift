import SwiftUIFlux

func appStateReducer(state: AppState, action: Action) -> AppState {
	var state = state
	
	state.mapState = mapStateReducer(state: state.mapState, action: action)
//	state.featureInteractionState = featureInteractionStateReducer(state: state.featureInteractionState, action: action)
	
	return state
}
