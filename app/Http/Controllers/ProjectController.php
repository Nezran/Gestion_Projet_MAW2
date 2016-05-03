<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Project;
use App\Models\Task;
//use App\Http\Requests;
use App\Http\Middleware\ProjectControl;
use Illuminate\Support\Facades\Auth;
use Illuminate\Form;


class ProjectController extends Controller
{
    //

    public function __construct()
    {
        $this->middleware('ProjectControl', ['except' => [
            'index','create','store'
        ]]);
    }


    public function index()
    { // tout les projets

        // var_dump(Project::find(1));
        //$usertest = Project::where();
        //echo $usertest->users->first()->firstname;

        //Auth::user()->projectsUsers;

        if (Auth::user()) {

            $projects = Auth::user()->projects()->get();

            return view('project', ['projects' => $projects]);

            /*
            //dd(Project::all()[0]);
            foreach($projects as $project){

                /*$totuser = count(Project::find($project->id)->users);
                $totuser = $totuser -1;*/

            //$projetnom[$project->id] = Project::find($project->id)->name;

            //$data[] = [Project::find($project->id), Project::find($project->id)->users];

            /*for($i = 0; $i <= $totuser ; $i++ ){
                echo Project::find($project->id)->users[$i]->firstname." ";
                echo Project::find($project->id)->users[$i]->lastname." ";
                $utilisateur[] = Project::find($project->id)->users[$i]->firstname;
                echo "<br>";
            }*/

        }
    }


    public function show(Request $request)
    {

        if( $request->ajax() ) {
            echo "ajax?";
        }

        
       //dd(Project::find($request->id));
        //$tasks = Task::project();
        $project = Project::find($request->id);
        //dd($project->tasks[0]->allChildren()->get());

        /*foreach($tasks as $child => $parent) {
            echo $child;
            echo $parent;
        }*/


        //dd($project->tasks[1]->parent);

        /*
        function buildtree($tasks)
        {

            $tree = array();
            echo "<ul>";
            foreach ($tasks as $task) {
                echo "<li>" . $task->id . "</li>";
                $tree[] = [
                    'parent' => $task,
                    'children' => buildtree($task->children)
                ];
            }
            echo "</ul>";
            return $tree;
        }

        $tasksTree = buildtree($project->tasksParent);
        */

        return view('project/show', ['project' => $project, 'request' => $request]);
    }

    public function files()
    {
        return view('project/show');
    }

    public function edit()
    {
        return view('project/edit');
    }

    public function task()
    {
        return view('project/task');
    }

    public function create()
    {
        return view('project/edition/create');
    }

    public function store(Request $request)
    {
        dd($request->input('date'),$request->input('name'),$request->input('description'));
        //return view('project/edition/create');
    }

    public function destroy(Request $request, $id)
    {
        $response = [];
        $activity = Activity::find($id);
        if( !$activity ) {
            $response = [
                'status'    =>  'error',
                'message'   =>  'Cette publication n\'existe pas',
            ];
        }

        if( !$this->authorize('destroy', $activity) ) {
            $response = [
                'status'    =>  'error',
                'message'   =>  'Vous n\'avez pas l\'autorisation de supprimer cette publication',
            ];
        }

        if( $activity->delete() ) {
            $response = [
                'id'        =>  $id,
                'status'    =>  'success',
                'message'   =>  'La publication a été supprimée !',
            ];
        } else {
            $response = [
                'status'    =>  'error',
                'message'   =>  'Une erreur est survenue durant la suppression'
            ];
        }

        if( $request->ajax() ) {
            return new JsonResponse($response);
        } else {
            alert()->{$response['status']}($response['message']);
            return redirect()->route('front.index');
        }
    }


}

 