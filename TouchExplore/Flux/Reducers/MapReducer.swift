import SwiftUIFlux

func mapStateReducer(state: MapState, action: Action) -> MapState {
	var state = state
	
	switch action {
		case let action as MapActions.ChangeFeatures:
			state.features = action.features
		case _ as MapActions.ZoomIn:
			state.zoomLevel += 1
		case _ as MapActions.ZoomOut:
			state.zoomLevel -= 1
		case let action as MapActions.SetZoomLevel:
			state.zoomLevel = action.zoomLevel
		default:
			break
	}
	
	return state
}
