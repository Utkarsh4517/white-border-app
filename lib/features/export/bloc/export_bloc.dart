import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'export_event.dart';
part 'export_state.dart';

class ExportBloc extends Bloc<ExportEvent, ExportState> {
  ExportBloc() : super(ExportInitial()) {
    on<ExportEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

