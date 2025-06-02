<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/all.css" integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU" crossorigin="anonymous">
    <title>Login Form</title>
    <style>
        #logreg-forms {
            width: 412px;
            margin: 10vh auto;
            background-color: #f3f3f3;
            box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);
            transition: all 0.3s cubic-bezier(.25,.8,.25,1);
        }
        #logreg-forms form {
            width: 100%;
            max-width: 410px;
            padding: 15px;
            margin: auto;
        }
        #logreg-forms .form-control {
            position: relative;
            box-sizing: border-box;
            height: auto;
            padding: 10px;
            font-size: 16px;
        }
        #logreg-forms .form-control:focus { z-index: 2; }
        #logreg-forms .form-signin input[type="email"] {
            margin-bottom: -1px;
            border-bottom-right-radius: 0;
            border-bottom-left-radius: 0;
        }
        #logreg-forms .form-signin input[type="password"] {
            border-top-left-radius: 0;
            border-top-right-radius: 0;
        }
        #logreg-forms .social-login {
            width: 390px;
            margin: 0 auto;
            margin-bottom: 14px;
        }
        #logreg-forms .social-btn {
            font-weight: 100;
            color: white;
            width: 190px;
            font-size: 0.9rem;
        }
        #logreg-forms a {
            display: block;
            padding-top: 10px;
            color: lightseagreen;
        }
        #logreg-form .lines {
            width: 200px;
            border: 1px solid red;
        }
        #logreg-forms button[type="submit"] { margin-top: 10px; }
        #logreg-forms .facebook-btn { background-color: #3C589C; }
        #logreg-forms .google-btn { background-color: #DF4B3B; }
        #logreg-forms .form-reset, #logreg-forms .form-signup { display: none; }
        #logreg-forms .form-signup .social-btn { width: 210px; }
        #logreg-forms .form-signup input { margin-bottom: 2px; }
        .form-signup .social-login {
            width: 210px !important;
            margin: 0 auto;
        }
        @media screen and (max-width: 500px) {
            #logreg-forms {
                width: 300px;
            }
            #logreg-forms .social-login {
                width: 200px;
                margin: 0 auto;
                margin-bottom: 10px;
            }
            #logreg-forms .social-btn {
                font-size: 1.3rem;
                font-weight: 100;
                color: white;
                width: 200px;
                height: 56px;
            }
            #logreg-forms .social-btn:nth-child(1) {
                margin-bottom: 5px;
            }
            #logreg-forms .social-btn span {
                display: none;
            }
            #logreg-forms .facebook-btn:after {
                content: 'Facebook';
            }
            #logreg-forms .google-btn:after {
                content: 'Google+';
            }
        }
    </style>
</head>
<body>
    <div id="logreg-forms">
        <form class="form-signin" action="login" method="post">
            <h1 class="h3 mb-3 font-weight-normal text-center"> Sign in</h1>
            <p class="text-danger">${mess}</p>
            <input name="user" type="text" class="form-control" placeholder="Username" required autofocus>
            <input name="pass" type="password" class="form-control" placeholder="Password" required>

            <div class="form-group form-check">
                <input name="remember" value="1" type="checkbox" class="form-check-input" id="exampleCheck1">
                <label class="form-check-label" for="exampleCheck1">Remember me</label>
            </div>

            <button class="btn btn-success btn-block" type="submit"><i class="fas fa-sign-in-alt"></i> Sign in</button>
            <hr>
            <button class="btn btn-primary btn-block" type="button" id="btn-signup"><i class="fas fa-user-plus"></i> Sign up New Account</button>
        </form>

        <form action="signup" method="post" class="form-signup" style="display: none;">
            <h1 class="h3 mb-3 font-weight-normal text-center"> Sign up</h1>
            <input name="user" type="text" class="form-control" placeholder="User name" required autofocus>
            <input name="pass" type="password" class="form-control" placeholder="Password" required>
            <input name="repass" type="password" class="form-control" placeholder="Repeat Password" required>

            <button class="btn btn-primary btn-block" type="submit"><i class="fas fa-user-plus"></i> Sign Up</button>
            <a href="#" id="cancel_signup"><i class="fas fa-angle-left"></i> Back</a>
        </form>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script>
        function toggleSignUp(e) {
            e.preventDefault();
            $('.form-signin, .form-signup').toggle();
        }

        $(document).ready(() => {
            $('#btn-signup, #cancel_signup').click(toggleSignUp);
        });
    </script>
</body>
</html>