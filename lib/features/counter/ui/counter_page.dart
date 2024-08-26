// ignore_for_file: type_literal_in_constant_pattern

import 'package:bloc_counter/features/counter/bloc/counter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final CounterBloc counterBloc = CounterBloc(); // instance of bloc
  @override
  void initState() {
    // as soon as the counter_page screen is rendered, it is going to add my increment event
    // for default to show 1 (else Not found will be displayed)
    counterBloc.add(CounterIncrementEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Counter Page")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          counterBloc.add(CounterIncrementEvent());
        },
      ),
      body: BlocConsumer<CounterBloc, CounterState>(
        bloc: counterBloc,
        // I want to listen, when state is an Action State
        listenWhen: (previous, current) => current is CounterActionState,
        // I want to build, when state is not an Action State
        buildWhen: (previous, current) => current is! CounterActionState,
        listener: (context, state) {
          if (state is CounterShowSnackBarActionState) {
            // similarly we can write navigations, setState, or other functions as well
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Snackbar")));
          }
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            case CounterIncrementState:
              final successState = state as CounterIncrementState;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      successState.value.toString(),
                      style: const TextStyle(fontSize: 25),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          counterBloc.add(CounterShowSnackBarEvent());
                        },
                        child: const Text("Snackbar"))
                  ],
                ),
              );
            // if not getting CounterIncrementState, then this:
            default:
              return const Center(
                child: Text("Not Found"),
              );
          }
        },
      ),
    );
  }
}


/* 
If using BlocConsumer (currently using):
BlocConsumer<CounterBloc, CounterState>(
        bloc: counterBloc,
        // I want to listen, when state is an Action State
        listenWhen: (previous, current) => current is CounterActionState,
        // I want to build, when state is not an Action State
        buildWhen: (previous, current) => current is! CounterActionState,
        listener: (context, state) {
          if (state is CounterShowSnackBarActionState) {
            // similarly we can write navigations, setState, or other functions as well
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Snackbar")));
          }
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            case CounterIncrementState:
              final successState = state as CounterIncrementState;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      successState.value.toString(),
                      style: const TextStyle(fontSize: 25),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          counterBloc.add(CounterShowSnackBarEvent());
                        },
                        child: const Text("Snackbar"))
                  ],
                ),
              );
            // if not getting CounterIncrementState, then this:
            default:
              return const Center(
                child: Text("Not Found"),
              );
          }
        },
      )
 */


/*  
If using BlocBuilder:

 body: BlocBuilder<CounterBloc, CounterState>(
        bloc: counterBloc,
        builder: (context, state) {
          switch (state.runtimeType) {
            case CounterIncrementState:
              final successState = state as CounterIncrementState;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      successState.value.toString(),
                      style: const TextStyle(fontSize: 25),
                    ),
                  ],
                ),
              );
            default:
              return const Center(
                child: Text("Not Found"),
              );
          }
        },
      ),
 */

/* 
If using BlocListener:

body: BlocListener<CounterBloc, CounterState>(
          bloc: counterBloc,
          listener: (context, state) {
            if (state is CounterShowSnackBarActionState) {
              // similarly we can write navigations, setState, or other functions as well
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Snackbar")));
            } else if (state is CounterIncrementActionState) {
              /* In BlocListener if we have to rebuild the text widget we will have to use setState which is not good,
             but it is must for rebuilding if we are using BlocListener, but for that BlocBuilder is correct approach.
             This was just to show u can achieve same thing using BlocListener as well, but not a good approach */
              setState(() {
                value = value + 1;
              });
            }
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value.toString(), style: const TextStyle(fontSize: 25)),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      // adding an event
                      counterBloc.add(CounterIncrementEvent());
                    },
                    child: const Text("Add")),
                ElevatedButton(
                    onPressed: () {
                      counterBloc.add(CounterShowSnackBarEvent());
                    },
                    child: const Text("Snackbar"))
              ],
            ),
          ),
        )
 */ 